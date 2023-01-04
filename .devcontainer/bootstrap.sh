#!/bin/sh -e

cd "$(dirname "$0")"

sudo mkdir -p /opt
sudo mv opt/* /opt

./run.d/00_apt.sh
./run.d/01_homebrew.sh
./run.d/02_system.sh
