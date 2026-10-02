# bob_shell

Ansible role that installs **IBM Bob Shell** on a RedHat-family Linux VM.

Bob Shell is the terminal-based CLI for IBM Bob — it provides AI-assisted automation,
scripting, and non-interactive task execution from the command line.

## Requirements

- Target host: RedHat / Fedora (RHEL 8+, Rocky, AlmaLinux)
- Network access to `bob.ibm.com` from the target VM
- An IBM Bob API key with **Inference** scope — generate one at https://bob.ibm.com

## Role Variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `bob_shell_api_key` | **yes** | — | IBM Bob API key (Inference scope). Set via `--extra-vars` or a vault. |
| `bob_shell_install_script_url` | no | `https://bob.ibm.com/download/bobshell.sh` | URL of the Bob Shell install script. |
| `bob_shell_profile_dir` | no | `/etc/profile.d` | Directory where the `BOBSHELL_API_KEY` env var is persisted system-wide. |
| `bob_shell_trusted_workspace` | no | `""` | If set, writes a `~/.bob/trustedFolders.json` entry for this path. |

## Usage

### Standalone playbook

```bash
ansible-playbook -i ./inventory.json \
  ./deploy-concert/playbooks/install_bob_shell.yml \
  --extra-vars bob_shell_api_key="YOUR_BOB_API_KEY"
```

### After Concert deployment

```bash
ansible-playbook -i ./inventory.json \
  ./deploy-concert/playbooks/install_concert_vm.yml \
  --extra-vars ibm_entitlement_key="YOUR KEY" \
  --extra-vars bob_shell_api_key="YOUR BOB API KEY"
```

## Post-install

Bob Shell is installed at `/usr/local/bin/bob`.  
The API key is persisted in `/etc/profile.d/bobshell.sh` (mode `0600`, root-only).

Run a non-interactive prompt:

```bash
source /etc/profile.d/bobshell.sh
bob --auth-method api-key -P "Explain this project"
```
