output "public_ip" {
  value = aws_instance.lab.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.api.repository_url
}