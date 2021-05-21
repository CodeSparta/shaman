# Automation Dependencies

- Ansible leverages the community.general collection and govc command
- Terraform leverages the vsphere plugin

### Assumptions

- Ansible version >= 2.9.16 present on Ansible control node
- oc and openshift-install binaries installed and available to user
- Webserver (i.e. apache/nginx) available on the same server that runs automation and configured
- RHCOS ova is located in the webserver referenced above
- Ansible control node is able to resolve Vcenter endpoint & domain
- Ansible control node is able to resolve cluster DNS
- Ansible `govc` commands are issued insecurely to Vcenter; if desired secure, will need to change in playbooks and import Vcenter cert

### Steps to prepare dependencies for automation

- Install community.general collection (e.g. `sudo ansible-galaxy collection install community-general-2.0.1.tar.gz -p /usr/share/ansible/collections/`)
- Install Terraform v0.14.4 (e.g. copy binary to location available to user)
- Install govc (e.g. copy binary to location available to user)
- 
