#!/bin/sh -ex

GH_RAW_URL=https://raw.githubusercontent.com
INSTALL_SCRIPT=install.sh
INSTALL_URL="${GH_RAW_URL}/Homebrew/install/HEAD/${INSTALL_SCRIPT}"

# Signal to the Homebrew installer that we can run as root
sudo touch /.dockerenv

tmp_dir="$(mktemp -d)"
clean() { rm -rf "${tmp_dir}"; }
trap clean EXIT

cd "${tmp_dir}"
wget -q "${INSTALL_URL}" -O "${INSTALL_SCRIPT}"
chmod 755 "${INSTALL_SCRIPT}"
NONINTERACTIVE=false
export NONINTERACTIVE
HOMEBREW_INSTALL_FROM_API=true
export HOMEBREW_INSTALL_FROM_API
"./${INSTALL_SCRIPT}"

brew install \
    bash-completion@2 \
    direnv \
    gcc \
    gh \
    git
