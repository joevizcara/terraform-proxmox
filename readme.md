
# [draft]Managing Proxmox VE using Terraform

This program enables a declarative manner of provisioning multiple resources in your Proxmox VE.

## Deployment

1. Clone this repository.

Go to GitLab Project/Repository > Settings > CI/CD > Runner > Create project runner
Click Run untagged jobs and Create runner.
On Step 1, copy the runner authentication token, store it somewhere and click `View runners`.



1. Right-click on a Proxmox node and click `Shell`
2. Execute this command in the shell.

```bash
bash <(curl -s https://gitlab.com/joevizcara/terraform-proxmox/-/raw/master/prep.sh)
```

> [!CAUTION]
> Please examine the content of this shell script before executing it. You can execute it on a virtualized Proxmox VE to observe what it does.
> It will create a privileged PAM user to authenticate via a token. Because the API limitation of the Terraform provider, it will also need to add the SSH public key to the authorized keys to write the cloud-init configuration YAML files to the local Snippets datastore. It creates a small LXC environment for GitLab Runner to manage the Proxmox resources. It will be adding a few more data types that can be accepeted in the local datastore (e.g. Snippets, Import).

3.
