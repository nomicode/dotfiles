#!/bin/sh -ex

tmp_dir="$(mktemp -d)"
clean() { rm -rf "${tmp_dir}"; }
trap clean EXIT

# Custom sources
# -----------------------------------------------------------------------------

cd "${tmp_dir}"

NODESOURCE_URL=https://deb.nodesource.com/setup_19.x
NODESOURCE_SCRIPT=nodesource_setup.sh

# Set up APT for latest Node.js
wget -q "${NODESOURCE_URL}" -O "${NODESOURCE_SCRIPT}"
chmod 755 "${NODESOURCE_SCRIPT}"
sudo "./${NODESOURCE_SCRIPT}"

YARN_DEB_REPO=https://dl.yarnpkg.com/debian
YARN_PUBKEY_URL="${YARN_DEB_REPO}/pubkey.gpg"
YARN_PUBKEY=pubkey.gpg
YARN_KEY_PATH="/usr/share/keyrings/yarnkey.gpg"
YARN_LIST=/etc/apt/sources.list.d/yarn.list

# Set up APT for latest Yarn
wget -q "${YARN_PUBKEY_URL}" -O "${YARN_PUBKEY}"
sudo rm -f "${YARN_KEY_PATH}"
sudo gpg --dearmor --output "${YARN_KEY_PATH}" "${YARN_PUBKEY}"
cat <<EOF
deb [signed-by=${YARN_KEY_PATH}] ${YARN_DEB_REPO} stable main
EOF | sudo tee -a "${YARN_LIST}" 

# APT setup
# -----------------------------------------------------------------------------

DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND

sudo apt-get -q update -y
sudo apt-get -q install -y --no-install-recommends \
    acl \
    build-essential \
    cronic \
    gcc \
    nodejs \
    yarn
sudo rm -rf /var/lib/apt/lists/*
