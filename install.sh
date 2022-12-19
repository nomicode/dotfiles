#!/bin/sh -e

rsync -av --copy-links home/ "${HOME}"

if test -n "${SSH_PRIVATE_KEY}"; then
    mkdir -p "${HOME}/.ssh"
    echo "${SSH_PRIVATE_KEY}" > "${HOME}/.ssh/id_rsa"
    chmod 600 "${HOME}/.ssh/id_rsa"
fi
