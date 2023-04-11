provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

# Network

resource "oci_core_vcn" "code_server_vcn" {
  cidr_blocks    = ["10.0.0.0/16"]
  compartment_id = var.compartment_ocid

  display_name = "code-server-vcn"
  dns_label    = "csvcn"

}

resource "oci_core_subnet" "code_server_subnet" {
  cidr_block     = "10.0.1.0/24"
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.code_server_vcn.id

  display_name      = "code-server-subnet"
  dns_label         = "cssubnet"
  route_table_id    = oci_core_route_table.code_server_route_table.id
  security_list_ids = [oci_core_security_list.code_server_security_list.id]
}

resource "oci_core_internet_gateway" "code_server_internet_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.code_server_vcn.id
  display_name   = "codeServerIG"
}

resource "oci_core_route_table" "code_server_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.code_server_vcn.id

  display_name = "codeServerRouteTable"
  route_rules {
    network_entity_id = oci_core_internet_gateway.code_server_internet_gateway.id

    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
}

resource "oci_core_security_list" "code_server_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.code_server_vcn.id

  display_name = "code-server-security-rules"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"

    description = "Allow code server to access internet."
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    description = "SSH"
    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    description = "HTTP"
    tcp_options {
      max = "80"
      min = "80"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    description = "HTTPS"
    tcp_options {
      max = "443"
      min = "443"
    }
  }
}

# Instances

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

resource "oci_core_instance" "code_server" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_name
  shape               = var.instance_type

  shape_config {
    ocpus         = var.cpu
    memory_in_gbs = var.memory_gb
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.code_server_subnet.id
  }

  source_details {
    source_type = "image"
    source_id   = local.image_map[var.image]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = filebase64("${path.module}/code-server-init.yaml")
  }

  lifecycle {
    precondition {
      condition     = contains(keys(local.image_map), var.image)
      error_message = "Image \"${var.image}\" is not supported yet. Please choose from ${jsonencode(keys(local.image_map))}."
    }
  }
}
