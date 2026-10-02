# Concert VM

An Ansible Role that installs Concert and optionally the workflows application on a VM

Concert Version: **3.0.0**

## Notes

Since v3.0.0 Podman is no longer required. Everything runs on a single K3s cluster.
The OOB concert install script takes care of installing K3s and Helm.

## Requirements

Installation requires a user that can sudo (become: true)

> Only RHEL is supported at the moment.

| Node    | OS   | CPU (cores) | Memory (GB) | Additional Disks (GB) |
|---------|------|-------------|-------------|-----------------------|
| concert | RHEL | 16          | 32          | 512                   |



## Variables

### Input Variables

**Required Variables**
| Variable Name         | Description | Default Value |
|-----------------------|-------------|---------------|
| `ibm_entitlement_key` |             |               |


**Optional Variables**
| Variable Name                    | Description                                             | Default Value                                                      |
|----------------------------------|---------------------------------------------------------|--------------------------------------------------------------------|
| `concert_user`                   | Username to login to Concert                            | ibmconcert                                                         |
| `concert_password`               | Password to login to Concert                            | Passw0rd                                                           |
| `install_workflows`              | Install the Workflows application                       | `true`                                                             |
| `install_dataapps`               | Install the Data Apps application                       | `true`                                                             |
| `install_securecoder`            | Install the Secure Coder feature                        | `true`                                                             |
| `install_buddy`                  | Install the Buddy feature                               | `true`                                                             |
| `enable_watsonx`                | Enable watsonx.ai integration. When `true`, the 3 `watsonx_api_*` variables below are required. | `false`                                 |
| `watsonx_api_key`                | watsonx.ai API key. Required when `enable_watsonx` is `true`. Should be supplied via Ansible vault. | `""`                                   |
| `watsonx_api_project_id`         | watsonx.ai project ID. Required when `enable_watsonx` is `true`. | `""`                                                      |
| `watsonx_api_url`                | watsonx.ai API URL. Required when `enable_watsonx` is `true`. | `""`                                                         |
| `local_k3s_kubeconfig_file_path` | Path to the kubeconfig created by k3s on the concert vm | `/etc/rancher/k3s/k3s.yaml`                                        |


**Configurable Defaults**
Listed in [defaults/main.yml](./defaults/main.yml)

### Output Variables

See [tasks/main.yml](./tasks/main.yml) for the variables set as a fact.

## Dependencies

None

## Example Usage

### Inventory

```json
{
  "concert": {
    "hosts": {
      "concert": {
        "ansible_host": "9.x.x.x",
        "ansible_user": "root",
        "ansible_ssh_pass": "...",
        "ansible_become_pass": "...",
        "private_ip": "10.x.x.x",
        "host_fqdn": "concert.fyre.ibm.com"
      }
    }
  }
}
```

### Playbook

```yaml
- name: Install Concert on a VM
  hosts: concert
  gather_facts: true
  vars:
    ibm_entitlement_key: "{{ ibm_entitlement_key }}"
  tasks:
    - name: Install Concert
      ansible.builtin.import_role:
        name: ../roles/concert_vm
```

### Direct

```bash
  ansible-playbook -i /ansible/hosts playbooks/install_concert_vm.yml \
    --extra-vars ibm_entitlement_key="..."
```

### Enabling watsonx.ai

####> IMPORTANT <#######

NOTE:   make sure you pass enable_watsonx as a JSON string !! otherwise
passing the value as a string "false", which is non-empty and therefore truthy 

######################

To have the role configure watsonx.ai credentials during installation (previously a manual post-install step), set --extra-vars '{"enable_watsonx": true}'  and supply the `watsonx_api_*` variables. The API key is sensitive and should be kept in an Ansible vault file rather than passed on the command line:

```bash
  ansible-playbook -i /ansible/hosts playbooks/install_concert_vm.yml \
    --extra-vars ibm_entitlement_key="..." \
    --extra-vars '{"enable_watsonx": true}'  \
    --extra-vars watsonx_api_project_id="..." \
    --extra-vars watsonx_api_url="..." \
    --extra-vars "@vault/watsonx.yml" --ask-vault-pass
```

The role writes the four values as a secret and restarts `ibm-roja-py-utils` to apply them. Look at install.yml for details

## Other Notes

### Concert API Docs

- https://developer.ibm.com/apis/catalog/concert--ibm-concert-api/Introduction
