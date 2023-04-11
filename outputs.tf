output "code-server-public-ip" {
  description = "Code server public IP."
  value       = oci_core_instance.code_server.public_ip
}

output "code-server-instance-name" {
  description = "Code server instance name."
  value       = oci_core_instance.code_server.display_name
}