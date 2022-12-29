# shellcheck shell=sh

# Default code
# =============================================================================
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n 2> /dev/null || true

# Custom code
# =============================================================================

eval "$(ssh-agent bash)"

SSH_KEY_FILE="${HOME}/.ssh/id_rsa"
if test -s "${SSH_KEY_FILE}"; then
    ssh-add "${SSH_KEY_FILE}"
fi
unset SSH_KEY_FILE

BASH_COMPLETION_FILE="$(brew --prefix)/etc/profile.d/bash_completion.sh"
if test -f "${BASH_COMPLETION_FILE}"; then
  . "${BASH_COMPLETION_FILE}"
fi
unset BASH_COMPLETION_FILE

eval "$(direnv hook bash)"
