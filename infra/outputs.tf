output "public_key_id" {
  value = aws_cloudfront_public_key.main.id
}

output "private_key" {
  sensitive = true
  value = tls_private_key.main.private_key_pem
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.main.domain_name
}
