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
echo "username:"
echo $INPUT_REPO_USERNAME | head -c 3
echo ""
echo "passwd:"
echo $INPUT_REPO_PASS | head -c 10
echo ""
echo "repo"
echo $INPUT_REPO | head -c 10
echo ""

docker login -u $INPUT_REPO_USERNAME -p $INPUT_REPO_PASS $INPUT_REPO

echo "Connecting to $INPUT_SSH_HOST..."
#docker --log-level debug --host "ssh://docker-server" "$@" 2>&1
