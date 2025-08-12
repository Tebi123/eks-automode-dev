# outputs.tf

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.dev.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.dev_public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.dev_private[*].id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.dev.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.dev.id
}

output "nat_eip" {
  description = "Elastic IP address for NAT Gateway"
  value       = aws_eip.dev.public_ip
}
