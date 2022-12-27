# =============================================================================
# Project build
# =============================================================================

.EXPORT_ALL_VARIABLES:

# POSIX locale
LC_ALL = C

# ANSI formatting
B = [1m
U = [4m
RED = [0;31m
RST = [0m

TOP_DIR = $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

# Primary targets
# =============================================================================

.PHONY: help
# -----------------------------------------------------------------------------

.DEFAULT_GOAL = help

help:
	@ printf 'Usage: \e$(B)make\e$(RST) [ target ]\n\n'
	@ printf 'Available targets:\n\n'
	@ grep -E '^.PHONY: [a-z-]+ #' Makefile | \
		sed -E 's,^.PHONY: ([a-z-]+) # (.*),\1#\2,' | \
		column -s '#' -t | \
		sed -E "s,^([a-z-]+),  \x1b$(B)\1\x1b$(RST),"


.PHONY: install # Install the project dependencies
# -----------------------------------------------------------------------------

install: .git/config node_modules

.git/config: node_modules
	yarn trunk git-hooks sync

node_modules: package.json
	yarn install
	cspell link add @cspell/dict-shell
	touch $@

.PHONY: upgrade # Upgrade the project dependencies
# -----------------------------------------------------------------------------

upgrade:
	yarn upgrade

.PHONY: check # Check new and changed files
# -----------------------------------------------------------------------------

check: install
	yarn trunk check

.PHONY: check-all # Check all files in the repository
# -----------------------------------------------------------------------------

check-all:
	yarn trunk check --all

.PHONY: format # Format new and changed files
# -----------------------------------------------------------------------------

format:
	yarn trunk fmt


.PHONY: format-all # Format all files in the repository
# -----------------------------------------------------------------------------

format-all:
	yarn trunk fmt --all

# Clean
# -----------------------------------------------------------------------------

.PHONY: clean # Remove build artifacts
clean: _rm-empty-dirs

.PHONY: _rm-empty_-irs
_rm-empty-dirs: _git-clean
	find . -type d -empty -delete

.PHONY: _git-clean
# Remove files that match `.gitignore` (but keep untracked files)
_git-clean:
	git clean -f -d -X


