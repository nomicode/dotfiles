#!/bin/sh -ex

# Run whenever the contents of the workspace mount are updated
# https://containers.dev/implementors/json_reference/#lifecycle-scripts

workspace_dir="${1:=}"

if test -z "${workspace_dir}"; then
    echo "Usage: ${0} WORKSPACE_DIR" >&2
    exit 1
fi

# Remove ACLs on files in the workspace mount so that the default system umask
# is respected
# https://github.com/orgs/community/discussions/26026#discussioncomment-3250078
whoami="$(whoami)"
sudo chown -R "${whoami}" "${workspace_dir}"

which setfacl || true
which direnv || true
ls -l /home || true

sudo setfacl -bnR "${workspace_dir}"

# Allow direnv to load `.envrc` files in the workspace mount
direnv allow "${workspace_dir}"
