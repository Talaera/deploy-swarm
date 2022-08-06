#!/bin/sh
set -eu

echo "Registering SSH keys..."

# Save private key to a file and register it with the agent.
mkdir -p "$HOME/.ssh"
printf '%s' "$INPUT_SSH_PRIVATE_KEY" > "$HOME/.ssh/docker"
chmod 600 "$HOME/.ssh/docker"
eval $(ssh-agent)
ssh-add "$HOME/.ssh/docker"

# Add public key to known hosts.
printf '%s %s\n' "$INPUT_SSH_HOST" "$INPUT_SSH_PUBLIC_KEY" >> /etc/ssh/ssh_known_hosts
printf '%s %s\n' "$INPUT_SSH_PROXY_HOST" "$INPUT_SSH_PROXY_PUBLIC_KEY" >> /etc/ssh/ssh_known_hosts

# Put correct values into ssh config file

# Couldn't figure how to copy config file straight to $HOME/.ssh/ folder during build stage, so here it is.
cp /config $HOME/.ssh/config
sed -i -e 's/%user%/'"$INPUT_SSH_USER"'/g' $HOME/.ssh/config
sed -i -e 's/%hostname%/'"$INPUT_SSH_HOST"'/g' $HOME/.ssh/config
sed -i -e 's/%proxy_user%/'"$INPUT_SSH_PROXY_USER"'/g' $HOME/.ssh/config
sed -i -e 's/%proxy_hostname%/'"$INPUT_SSH_PROXY_HOST"'/g' $HOME/.ssh/config

echo "Connecting to $INPUT_SSH_HOST..."
cat $HOME/.ssh/config
docker --log-level debug --host "ssh://docker-server" "$@" 2>&1
