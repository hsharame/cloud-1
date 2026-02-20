output "instance_id" {
  description = "EC2 instance id"
  value       = aws_instance.ws.id
}

output "public_ip" {
  description = "Public IPv4"
  value       = aws_instance.ws.public_ip
}

output "public_dns" {
  description = "Public DNS name"
  value       = aws_instance.ws.public_dns
}
