output "instance_id" {
  value = aws_instance.firewall.id
}

output "mgmt_public_ip" {
  value = aws_eip.mgmt.public_ip
}

output "mgmt_interface_id" {
  value = aws_network_interface.mgmt.id
}

output "eth1_public_ip" {
  value = aws_eip.eth1.public_ip
}

output "eth1_interface_id" {
  value = aws_network_interface.eth1.id
}

output "eth2_interface_id" {
  value = aws_network_interface.eth2.id
}
