#!/bin/sh -e

rsync -av --copy-links home/ "${HOME}"

git config --global push.default current
