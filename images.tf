data "oci_core_images" "ubuntu_22_04" {
  compartment_id   = var.compartment_ocid
  operating_system = "Canonical Ubuntu"
  filter {
    name   = "display_name"
    values = ["^Canonical-Ubuntu-22.04-([\\.0-9-]+)$"]
    regex  = true
  }
}

locals {
  image_map = {
    "Ubuntu 22.04" = data.oci_core_images.ubuntu_22_04.images.0.id
  }
}
