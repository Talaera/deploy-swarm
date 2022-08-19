#!/bin/sh
set -eu

echo "Registering SSH keys..."

# Save private key to a file and register it with the agent.
mkdir -p "$HOME/.ssh"
echo "$INPUT_SSH_PRIVATE_KEY" > "$HOME/.ssh/docker.pem"
chmod 600 "$HOME/.ssh/docker.pem"
eval $(ssh-agent)
ssh-add "$HOME/.ssh/docker.pem"

# Add public key to known hosts.
printf '%s %s\n' "$INPUT_SSH_HOST" "$INPUT_SSH_PUBLIC_KEY" >> /etc/ssh/ssh_known_hosts
printf '%s %s\n' "$INPUT_SSH_PROXY_HOST" "$INPUT_SSH_PROXY_PUBLIC_KEY" >> /etc/ssh/ssh_known_hosts

# Put correct values into ssh config file
sed -i -e 's/%user%/'"$INPUT_SSH_USER"'/g' /etc/ssh/ssh_config
sed -i -e 's/%hostname%/'"$INPUT_SSH_HOST"'/g' /etc/ssh/ssh_config
sed -i -e 's/%proxy_user%/'"$INPUT_SSH_PROXY_USER"'/g' /etc/ssh/ssh_config
sed -i -e 's/%proxy_hostname%/'"$INPUT_SSH_PROXY_HOST"'/g' /etc/ssh/ssh_config
sed -i -e 's|%identity_file%|'"$HOME"'/.ssh/docker.pem|g' /etc/ssh/ssh_config

echo "Setting up credentials..."
mkdir $HOME/.docker
echo "$INPUT_REPO_CREDENTIALS" > $HOME/.docker/config.json

systemctl stop docker
systemctl start docker

echo "Connecting to $INPUT_SSH_HOST..."
docker --log-level debug --host "ssh://docker-server" "$@" 2>&1
