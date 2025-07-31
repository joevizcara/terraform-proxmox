#!/usr/bin/env sh
cat << 'EOF'
╭────────────────────────────────────╮
│   Proxmox GitOps - This script     │
│    will manifest an Ubuntu LXC     │
│     hosting GitLab Runner and      │
│  OpenTofu to manage your Proxmox   │
│ resources. Press Enter to proceed. │
╰────────────────────────────────────╯
EOF

read -p ""
echo The script is preparing your PVE.
echo Please maintain this console open.
sleep 3

VMID=100
EXISTING_VMIDS=$( ( qm list | awk 'NR>1 {print $1}' ; pct list | awk 'NR>1 {print $1}' ) | sort -nu )

does_vmid_exist() {
    local vmid=$1
    echo "$EXISTING_VMIDS" | grep -qw "$vmid"
}

while does_vmid_exist $VMID ; do
    VMID=$(( VMID + 1 ))
done

pveam download local ubuntu-24.04-standard_24.04-2_amd64.tar.zst

pct create $VMID local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst \
  --hostname gitlab-runner \
  --password glrnr \
  --unprivileged 1 \
  --cores 1 \
  --memory 512 \
  --swap 0 \
  --storage local-lvm \
  --rootfs 8 \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp \
  --onboot 1

pct start $VMID

sleep 7 && \

pct exec $VMID -- apt update
pct exec $VMID -- apt full-upgrade -y
pct exec $VMID -- apt install curl -y
pct exec $VMID -- curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
pct exec $VMID -- chmod +x install-opentofu.sh
pct exec $VMID -- ./install-opentofu.sh --install-method deb
pct exec $VMID -- wget https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh
pct exec $VMID -- chmod +x script.deb.sh
pct exec $VMID -- ./script.deb.sh
pct exec $VMID -- apt install gitlab-runner -y
read -p "Enter the Registration Token of your GitLab Project: " PROJECT_REGISTRATION_TOKEN && \
pct exec $VMID -- gitlab-runner register --non-interactive --url "https://gitlab.com/" --registration-token "$PROJECT_REGISTRATION_TOKEN" --executor "shell" --description "GitLab Runner on Proxmox Ubuntu LTS LXC" --maintenance-note "" --tag-list "" --run-untagged="true" --locked="false" --access-level="not_protected"
pct exec $VMID -- reboot

pveum user add tofu-user@pam

pveum group add tofu-group

pveum user modify tofu-user@pam -group tofu-group

pveum role add tofu-role -privs "Datastore.Allocate Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Group.Allocate Mapping.Audit Mapping.Modify Mapping.Use Permissions.Modify Pool.Allocate Pool.Audit Realm.Allocate Realm.AllocateUser SDN.Allocate SDN.Audit SDN.Use Sys.AccessNetwork Sys.Audit Sys.Console Sys.Incoming Sys.Modify Sys.PowerMgmt Sys.Syslog User.Modify VM.Allocate VM.Audit VM.Backup VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Console VM.Migrate VM.Monitor VM.PowerMgmt VM.Snapshot VM.Snapshot.Rollback"

pveum user token add tofu-user@pam tofu-token -privsep 0 > tofu-token.txt

pveum acl modify / -group tofu-group -role tofu-role

pvesm set local --content import,rootdir,images,iso,vztmpl,backup,snippets


cat << 'EOF'

- this script has created a new lxc container with vmid $VMID that is hosting opentofu
and a registered gitlab runner to manage your proxmox virtual infrastructure.
- the proxmox api token is in plain text at ./tofu-token.txt.
- consider deleting that file after saving it into somewhere secure.
EOF
