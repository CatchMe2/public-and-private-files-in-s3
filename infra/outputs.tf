output "bucket_name" {
  value = aws_s3_bucket.main.bucket
  description = "The name of the bucket"
}

output "bucket_arn" {
  value = aws_s3_bucket.main.arn
  description = "The arn of the bucket"
}

output "public_key_id" {
  value = aws_cloudfront_public_key.main.id
}

output "private_key" {
  sensitive = true
  value = tls_private_key.main.private_key_pem
}
