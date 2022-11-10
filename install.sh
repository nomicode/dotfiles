#!/bin/sh -e

rsync -av --copy-links home/ "${HOME}"
