# Code server on Oracle Cloud Infrastructure (OCI)

This is an IaC terraform repo creating a test [code-server](https://github.com/coder/code-server) on Oracle Cloud Infrastructure (OCI)

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/yunhailuo/code-server-oci/releases/latest/download/code-server-oci-1.0.0.zip)

Briefly, this will create a small stack with one compute instance being the code server. When terraform apply finishes, you should get the IP of the compute instance, i.e. the code server, created in terraform output. However, there is a good chance the cloud-init hasn't yet finished setting up the code server. Please wait a little; or if you know how, SSH into the instance using the `ssh_public_key` you provided and check cloud-init status using `cloud-init status`. Once SSH into the server, you should be able to get the code server password from the code-server config at `/home/ubuntu/.config/code-server/config.yaml`. There is no other good way to get the password yet. This server is not associated with any domains so you can only access it using its IP. Because this server uses self-signed certificate, you will get a warning about the connection to the site is not secure in your browser. You should consider further set this up with your own domain and certificate.

## OCI credentials and configuration

The default deployment here goes through OCI Resource Manager. That's why `fingerprint`, `private_key_path` and `user_ocid` are not required and default to an empty string. If you want to deploy using terraform directly, those are required for setting up terrafrom provider `oci` against your OCI account properly.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_core_instance.code_server](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_internet_gateway.code_server_internet_gateway](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_route_table.code_server_route_table](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_security_list.code_server_security_list](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_subnet.code_server_subnet](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_vcn.code_server_vcn](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vcn) | resource |
| [oci_core_images.ubuntu_22_04](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_images) | data source |
| [oci_identity_availability_domain.ad](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domain) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | compartment ocid where to create all resources | `string` | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | (Updatable) The total number of OCPUs available to the instance. | `number` | `1` | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | fingerprint of oci api private key | `string` | `""` | no |
| <a name="input_image"></a> [image](#input\_image) | The name of VM image to be used by compute instance. | `string` | `"Ubuntu 22.04"` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | (Updatable) A user-friendly name for the instance. Does not have to be unique, and it's changeable. | `string` | `"code-server"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The shape of an instance. | `string` | `"VM.Standard.E2.1.Micro"` | no |
| <a name="input_memory_gb"></a> [memory\_gb](#input\_memory\_gb) | (Updatable) The total amount of memory available to the instance, in gigabytes. | `number` | `1` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | path to oci api private key used | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | the oci region where resources will be created | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Public SSH keys to be included in the ~/.ssh/authorized\_keys file for the default user on the instance. To provide multiple keys, see docs/instance\_ssh\_keys.adoc. | `string` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | tenancy ocid where to create the sources | `string` | n/a | yes |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | ocid of user that terraform will use to create the resources | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_code-server-instance-name"></a> [code-server-instance-name](#output\_code-server-instance-name) | Code server instance name. |
| <a name="output_code-server-public-ip"></a> [code-server-public-ip](#output\_code-server-public-ip) | Code server public IP. |
<!-- END_TF_DOCS -->