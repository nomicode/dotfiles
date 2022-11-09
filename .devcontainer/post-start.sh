#!/bin/sh -ex

# Run after the devcontainer has successfully started
# https://containers.dev/implementors/json_reference/#lifecycle-scripts

workspace_dir="${1:=}"

if test -z "${workspace_dir}"; then
    echo "Usage: ${0} WORKSPACE_DIR" >&2
    exit 1
fi

# Remove ACLs on files in the workspace mount so that the default system umask
# is respected
# https://github.com/orgs/community/discussions/26026#discussioncomment-3250078
sudo chown -R "$(whoami)" "${workspace_dir}"
sudo setfacl -bnR "${workspace_dir}"
