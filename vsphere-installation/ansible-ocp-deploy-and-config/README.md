Name
====

Openshift Deployment

Automation Summary
------------------

This automation deploys an Openshift cluster on a disconnected environment using static IPs, ready for Day 1 configurations.  The automation primarily leverages Ansible and Terraform.  To apply Day 1 configurations, please see README_configuration.md.  The starting point is the Ansible, which includes:

Roles:
- ignition_configs: Creates the ignition configs required to provision cluster nodes (i.e. control plane & worker nodes).
- create_cluster: Uses the ignition configs created to provision cluster nodes via terraform.

Playbooks:
- create_cluster.yml: Runs ignition_configs and create_cluster roles, using the variables in the automation/ansible/vars directory.

Variables: All variables to be modified are located in the vars/deployment.yml and vars/vault.yml.

Notes on tasks not reflected in playbooks/roles:
- Adding compute nodes to existing cluster: Use the create_cluster.yml playbook to add compute nodes to the cluster.  Before running, add the node(s) to be created under the 'workers' variable map in vars/deployment.yml, and make sure to add it to the DNS and LoadBalancer configurations.  Note that it is not possible to create the new compute nodes with different disk space, memory, or cpu specifications than what was originally specified at deployment time.
- Adding resources to existing cluster nodes is unsupported via the automation - plan accordingly.  If, however, changing the resource specifications of a node(s) is required, it is possible to do manually: stop the node (note that workloads will be [evicted](https://docs.openshift.com/container-platform/4.6/nodes/nodes/nodes-nodes-rebooting.html)) and edit the resources in vSphere; if it is not possible to change the resource  through vSphere, create new compute nodes with the correct resource specifications using [this](https://docs.openshift.com/container-platform/4.6/installing/installing_vsphere/installing-restricted-networks-vsphere.html#machine-vsphere-machines_installing-restricted-networks-vsphere) method, and delete the old compute nodes once the new ones are successfully added and running the existing workload.

Dependencies
------------

Not included in automation:
- Ansible version 2.9.16 
- oc and openshift-install cli tools\*
- RHCOS ova\*

\*Use the ansible-ocp-mirror-images-and-operators automation to pull these resources

Included in automation:
- community.general collection for Ansible
- govc v0.24.0
- Terraform v0.14.4
- Terraform vsphere plugin 1.24.3\*

Note on dependencies:
- The oc & openshift-install cli tools and RHCOS ova file are not included in the automation because these may change according to the version of Openshift to be installed.  Please see point #2 in the [docs](https://docs.openshift.com/container-platform/4.6/installing/installing_vsphere/installing-restricted-networks-vsphere.html#installation-vsphere-machines_installing-restricted-networks-vsphere) for more information.  You may download the cli tools from [here](https://mirror.openshift.com/pub/openshift-v4/clients/ocp/) and the RHCOS ova from [here](https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/).
- The tools that are 'included in the automation' are located in the automation/dependencies directory.  \*Note that the terraform vsphere plugin is already included in the terraform folder, so it does not need to be installed - it is noted only for awareness.  All other cli tools/binaries will need to be installed or placed in the correct location and made available to the user running the automation.

Assumptions
-------------

- A webserver (i.e. apache/nginx) should be available and configured on the same server that runs automation; user running ansible should be able to copy files into the `html_path` (i.e. web content serving) directory.
- The RHCOS ova should be located in the webserver referenced above.
- Ansible control node should be able to resolve Vcenter endpoint & domain.
- Ansible control node should be able to resolve cluster DNS.
- All cli tools/binaries need to be available to the user.
- Note that the Ansible `govc` commands are issued insecurely to Vcenter; if secure communication is desired, the govc sections of the automation will need to be modified, and the Vcenter cert will need to be imported.
- **Important**: the versions of `oc` and `openshift-install` must match the version of the intended Openshift release (e.g. `4.6.15`) and the ova version should be the highest version that is less than or equal to the Openshift version intended.  For example, (at the time of writing this) if installing version 4.6.4, then oc & openshift-install will both be version 4.6.4, but the ova will be 4.6.1.

Prerequisites
-------------

Container Registry:
- The registry must have the container images that correspond to the version of Openshift to be installed.
- The registry must have a TLS cert.  You will need to copy this certificate into automation/ansible/roles/ignition_configs/templates/ and name the file `registry.crt`.
- Reference [this doc](https://docs.openshift.com/container-platform/4.6/installing/install_config/installing-restricted-networks-preparations.html) for more information.

DNS Server:
- The DNS server should have all required DNS entries for the Kubernetes API, Routes, Bootstrap, Master, and Worker nodes (static IP method is assumed).
- See the DNS entries [file](dependencies/ocptest.dev.com.db) for an example.
- See [this doc](https://docs.openshift.com/container-platform/4.6/installing/installing_vsphere/installing-restricted-networks-vsphere.html#installation-dns-user-infra_installing-restricted-networks-vsphere) for more information.

Load Balancer:
- You will need a load balancer(s) for the API and for Ingress traffic.
- See the haproxy.cfg [configuration](../dependencies/haproxy.cfg) for an example.
- See the [OpenShift docs](https://docs.openshift.com/container-platform/4.6/installing/installing_vsphere/installing-restricted-networks-vsphere.html#installation-network-user-infra_installing-restricted-networks-vsphere) for more information.

Variables
---------

All variables can be located in automation/ansible/vars/deployment.yml or automation/ansible/vars/vault.yml.  All variables need to be set.

    mirror_registry_user: ""

Username for internal/mirror container registry.

    mirror_registry_passwd: cloudctl

Password for internal/mirror container registry.

    cluster_name: ""

If your intended cluster and domain name is mycluster.basedomain.com, the cluster_name is *mycluster*.

    domain_name: ""

If the intended cluster and domain name is mycluster.basedomain.com, the domain name is *basedomain.com*.

    install_name: ""
    install_dir: "/home/{{ ansible_env.USER }}/{{ install_name }}"

Intended name of the installation directory.  This directory will be created in the ansible user's home directory.

    local_registry: ""

The registry domain name, and optionally the port, that the internal mirror registry uses to serve content (e.g. *myhostname:5000*)

    pullsecret_email: "admin@dev.com"

Specify the email address associated with the pull secret.

    webserver_url: "bastion.ocpcluster.dev.com:8080"

HTTP server serving ignition configs.
    

## vCenter Information

    datacenter: DEV.COM

Name of vSphere datacenter to host cluster.

    datastore: Int-Datastore-Test

vSphere datastore for cluster.

    folder: "ocp-test-2"

Intended folder to place template and VMs within vCenter.  This folder will be created if not found.

    vcenter_server: ocp-vcs01.dev.com

vCenter server fully-qualified host name or IP address.

    vcenter_user: ""

Username for vCenter.  This user must be able to create resources on vCenter, including static/persistent volume provisioning, OVF template deployment, and VM creation.

    vcenter_passwd: ""

Password for vCenter_user.

     
## Webserver vars

    use_httpd: true

use_httpd boolean used to copy ignitions into httpd server.  If set to false, bootstrap.ign will need to be copied to the webserver and made available.

    html_path: "/var/www/html"

Full webserver folder path - used to copy ignitions to webserver.
     

## Terraform vars

    terraform_dir : "../terraform"
     
Location of terraform automation.


## Cluster configuration

    guest_id: "coreos64Guest"

VM guest ID.

    resource_pool_id: ""

Name of resource cluster within vCenter, usually found under "Hosts & Clusters".

    network_id: ""

Name of VM network in vCenter (e.g. portgroup name).

    network_adapter_type: "vmxnet3"

VM Network Adapter type.

    disk_thin_provisioned: "true"

Whether or not the disk attached to VMs should be thin.  If false, will be Thick Provision Lazy Zeroed.

    disk_size:
      - name: "master"
        value: 200
      - name: "worker"
        value: 200
      - name: "infra"
        value: 200

Disk size for VMs.  Only change the values for each.  Minimum value is 120.  Please reference [these docs](https://docs.openshift.com/container-platform/4.6/installing/installing_vsphere/installing-restricted-networks-vsphere.html#minimum-resource-requirements_installing-restricted-networks-vsphere) for guidance.

    memory:
      - name: "master"
        value: 16384
      - name: "worker"
        value: 32768
      - name: "infra"
        value: 65536

Amount of memory for VMs.  Only change the values for each.  Default value is 32G for infras/workers, 16 for masters.  Please reference [these docs](https://docs.openshift.com/container-platform/4.6/installing/installing_vsphere/installing-restricted-networks-vsphere.html#minimum-resource-requirements_installing-restricted-networks-vsphere) for guidance.

    num_cpus:
      - name: "master"
        value: 8
      - name: "worker"
        value: 8
      - name: "infra"
        value: 8

Number of CPUs for VMs.  Only change the values for each.  Default/minimum value is 120.  Please reference [these docs](https://docs.openshift.com/container-platform/4.6/installing/installing_vsphere/installing-restricted-networks-vsphere.html#minimum-resource-requirements_installing-restricted-networks-vsphere) for guidance.

    ova_file: ""

Name of ova file to be used for VMs.  This file should be in the webserver available to the cluster.

    dns_address: ""

IP address of DNS server - should be in the form of "nameserver=X.X.X.X".  If there are multiple DNS servers, they should be separated by a space, e.g. "nameserver=192.168.50.2 nameserver=192.168.51.2"

    gateway: ""

Gateway for cluster network.

    netmask: ""

Netmask for cluster network (e.g. "255.255.255.0").
   
    bootstrap: ""

Intended bootstrap static IP address (e.g. "10.1.1.155").  Note that the bootstrap is a temporary resource.

    masters:
      - name: "master0" 
        ip:  "10.1.1.160"
      - name: "master1"
        ip: "10.1.1.161"
      - name: "master2"
        ip: "10.1.1.162"

Intended control plane VM static IP addresses.

    infras:
      - name: "infra0" 
        ip:  "10.1.1.170"
      - name: "infra1"
        ip: "10.1.1.171"
      - name: "infra2"
        ip: "10.1.1.172"

Intended infra VM static IP addresses.  You may have more or less infra nodes.

    workers:
      - name: "worker0" 
        ip:  "10.1.1.163"
      - name: "worker1"
        ip: "10.1.1.164"
      - name: "worker2"
        ip: "10.1.1.165"
      - name: "worker3"
        ip: "10.1.1.166"

Intended worker VM static IP addresses.  You may have more or less worker nodes.

Running Automation
------------------

Assuming you have set all variables, you can navigate to automation/ansible.  In order to create a cluster, you will need a set of ignition configs and deploy a set of VMs using those ignition configs.  Therefore, by default, you should run the create_cluster.yml playbook:

`ansible-playbook create_cluster.yml --ask-vault-pass`

The playbook can take between 15 and 30 minutes to complete.

Post-deployment Steps
---------------------

The automation should provide you with a working Openshift cluster.  You can find the kubeconfig to login in {{ install_dir }}/auth/.  You may find the console url by issuing `KUBECONFIG=./auth/kubeconfig oc get route -n openshift-console`.


Adding New Nodes
---------------------

If you wish to add more nodes in any of the groups listed, you may do so simply by adding new entries in the corresponding group in vars/deployment.yml. Remember that masters group must be an odd number for OpenShift. For any node to add you must also remember to add it's static IP to your DNS and Loadbalancer. After this you can run the add_nodes.yml playbook:

`ansible-playbook add_nodes.yml --ask-vault-pass`

Adding nodes should take between 5-15 minutes depending on the number of nodes to add.
*Remember you must have a current version of terraform.tfvars in your terraform directory to add nodes. If you deleted the terraform.tfvars file, there is a backup file in your openshift install directory from your first cluster install that you can copy again. Remember to rename it to terraform.tfvars.*


Changing Registry
---------------------

If your private registry has been altered or has new certificates, OpenShift needs to be reconfigured with the new certificate. You can find directions on adding additional trust bundles for image registry access in the [docs](https://docs.openshift.com/container-platform/4.6/openshift_images/image-configuration.html#images-configuration-cas_image-configuration).

