#!/bin/sh -ex

# Switch default root shell
sudo sed -i 's,/root:/bin/ash,/root:/bin/bash,' /etc/passwd

# Disable VS Code first run notice
config_dir='${HOME}/.config/vscode-dev-containers'
mkdir -p "${config_dir}"
first_run_file='first-run-notice-already-displayed'
touch "${config_dir}/${first_run_file}"

# Set up direnv
cat >>"${HOME}/.profile" <<EOF

"\$(direnv export bash)"
EOF
