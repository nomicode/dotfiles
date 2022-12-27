#!/bin/sh -ex

# Install manifest files into the home directory
# =============================================================================

install_files() {
    source_dir="${1}"
    while read -r file; do
        install --compare -Dv "${source_dir}/${file}" "${HOME}"
    done <manifest.txt
}

install_files "$(pwd)"

# SSH keys
# =============================================================================

SSH_DIR="${HOME}/.ssh"
SSH_PUBKEY_FILE="${SSH_DIR}/id_rsa.pub"
SSH_KEY_FILE="${SSH_DIR}/id_rsa"

create_ssh_keys() {
    # Execute in a subshell and discard all output
    (
        # Exit if SSH key files already exist
        if test -s "${SSH_PUBKEY_FILE}" -o -s "${SSH_KEY_FILE}"; then
            exit 0
        fi
        # Write out env variables
        echo "${VSCODE_PUBLIC_KEY:=}" >"${SSH_PUBKEY_FILE}"
        echo "${VSCODE_PRIVATE_KEY:=}" >"${SSH_KEY_FILE}"
        # Check file sizes as a proxy for testing if variables were set
        if test -s "${SSH_PUBKEY_FILE}" -a -s "${SSH_KEY_FILE}"; then
            # Configure SSH key files and exit
            chmod 640 "${SSH_PUBKEY_FILE}"
            chmod 600 "${SSH_KEY_FILE}"
            exit 0
        fi
        # Clean up empty files
        rm -f "${SSH_PUBKEY_FILE}"
        rm -f "${SSH_KEY_FILE}"
        rmdir --ignore-fail-on-non-empty "${SSH_DIR}"
    ) >/dev/null 1>&2
}

create_ssh_keys

# Git
# =============================================================================

modify_git_conf() {
    git config --global commit.gpgsign true
    git config --global gpg.format ssh
    git config --global user.signingkey "${SSH_PUBKEY_FILE}"
}

modify_git_conf

DOTFILES_GIT="git@github.com:nomirose/dotfiles.git"
DOTFILES_DIR="${HOME}/dotfiles"

clone_dotfiles() {
    if ! test -d "${DOTFILES_DIR}"; then
        if test "$(pwd)" != "${DOTFILES_DIR}"; then
            git clone "${DOTFILES_GIT}" "${DOTFILES_DIR}"
        fi
    fi
}

clone_dotfiles
