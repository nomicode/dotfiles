#!/bin/sh -ex

# Install manifest files into the home directory
# =============================================================================

install_files() {
    source_dir="${1}"
    while read -r file; do
        install --compare -Dv "${source_dir}/${file}" "${HOME}/${file}"
    done <manifest.txt
}

install_files "${PWD}"

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
        mkdir -p "${SSH_DIR}"
        # Write out the SSH keys (using environment variables set by GitHub
        # from the repository secrets)
        (
            # Don't print secrets to stdout when this script run with the `-x`
            # argument
            set +x
            echo "Temporarily disabled command output to write secrets..."
            write_file() {
                perms="${1}"
                filename="${2}"
                env_var="${3}"
                secret="$(eval "echo \"\${${env_var}:=}\"")"
                if test -z "${secret}"; then
                    echo "Error: \`${env_var}\` is empty" >&2
                    exit 1
                fi
                echo "Writing \`${env_var}\` to the \`${filename}\` file..."
                echo "${secret}" >"${filename}"
                chmod "${perms}" "${filename}"
            }
            write_file 640 "${SSH_PUBKEY_FILE}" VSCODE_PUBLIC_KEY
            write_file 600 "${SSH_KEY_FILE}" VSCODE_PRIVATE_KEY
        )
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

DOTFILES_GIT="https://github.com/nomicode/dotfiles.git"
DOTFILES_DIR="${HOME}/dotfiles"

clone_dotfiles() {
    if ! test -d "${DOTFILES_DIR}"; then
        if test "${PWD}" != "${DOTFILES_DIR}"; then
            git clone "${DOTFILES_GIT}" "${DOTFILES_DIR}"
        fi
    fi
}

clone_dotfiles
