# provider identity parameters

variable "fingerprint" {
  description = "fingerprint of oci api private key"
  type        = string
  default     = ""
}

variable "private_key_path" {
  description = "path to oci api private key used"
  type        = string
  default     = ""
}

variable "region" {
  description = "the oci region where resources will be created"
  type        = string
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
}

variable "tenancy_ocid" {
  description = "tenancy ocid where to create the sources"
  type        = string
}

variable "user_ocid" {
  description = "ocid of user that terraform will use to create the resources"
  type        = string
  default     = ""
}

# general oci parameters

variable "compartment_ocid" {
  description = "compartment ocid where to create all resources"
  type        = string
}

# compute instance parameters

variable "instance_name" {
  description = "(Updatable) A user-friendly name for the instance. Does not have to be unique, and it's changeable."
  type        = string
  default     = "code-server"
}

variable "instance_type" {
  description = "The shape of an instance."
  type        = string
  default     = "VM.Standard.E2.1.Micro"
}

variable "cpu" {
  type        = number
  description = "(Updatable) The total number of OCPUs available to the instance."
  default     = 1
}

variable "memory_gb" {
  type        = number
  description = "(Updatable) The total amount of memory available to the instance, in gigabytes."
  default     = 1
}

variable "image" {
  type        = string
  description = "The name of VM image to be used by compute instance."
  # Known issue when using Ubuntu 22.04: https://github.com/adobe/fetch/pull/318#issuecomment-1306070259
  default = "Ubuntu 22.04"
}

# operating system parameters

variable "ssh_public_key" {
  description = "Public SSH keys to be included in the ~/.ssh/authorized_keys file for the default user on the instance. To provide multiple keys, see docs/instance_ssh_keys.adoc."
  type        = string
}
