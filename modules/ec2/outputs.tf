output "utility_instance_public_ip" {
  value = "ssh -i ${var.key_pair}.pem ubuntu@${aws_instance.utility_instance.public_dns}"
}

/*
output "web_instance_public_ip" {
  value = "ssh -i ${var.key_pair}.pem ubuntu@${aws_instance.web_instance.public_dns}"
}
*/
