# deploy-swarm GitHub Action

This repository provides a Docker-based GitHub Action that connects to a remote Docker daemon through an SSH jump host, then runs Docker CLI commands against that remote daemon. It is used by Talaera workflows to run one-off commands (like database migrations) and deploy Docker Swarm stacks on remote environments.

## What it does

- Sets up SSH credentials and known hosts for a target server and its jump host.
- Configures an SSH client to reach the target server via the jump host.
- Logs in to a Docker registry so the remote daemon can pull images.
- Executes the provided Docker CLI command on the remote daemon using Docker's `ssh://` transport.

## Inputs

All inputs are required and provided as GitHub Action inputs:

- `ssh_private_key`: Private key used to connect to the remote server.
- `ssh_public_key`: Server public key to add to `known_hosts`.
- `ssh_proxy_public_key`: Jump host public key to add to `known_hosts`.
- `ssh_user`: SSH username for the remote server.
- `ssh_host`: Remote server hostname or IP.
- `ssh_proxy_user`: SSH username for the jump host.
- `ssh_proxy_host`: Jump host hostname or IP.
- `repo`: Docker registry hostname (used for `docker login`).
- `repo_username`: Docker registry username.
- `repo_pass`: Docker registry password/token.

## Usage example

```yaml
- name: Run a one-off task
  uses: Talaera/deploy-swarm@main
  with:
    ssh_private_key: <ssh-private-key>
    ssh_public_key: <ssh-public-key>
    ssh_proxy_public_key: <ssh-proxy-public-key>
    ssh_user: <ssh-user>
    ssh_host: <ssh-host>
    ssh_proxy_user: <ssh-proxy-user>
    ssh_proxy_host: <ssh-proxy-host>
    repo: <registry-hostname>
    repo_username: <registry-username>
    repo_pass: <registry-password-or-token>
    args: run --rm --network <swarm-network> <registry-hostname>/<image>:<tag> <command>
```
