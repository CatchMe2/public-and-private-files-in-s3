resource "aws_s3_bucket" "main" {
  bucket = local.name_prefix
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_identity" "main" {
  comment = "access-to-${local.name_prefix}"
}

data "aws_iam_policy_document" "main" {
  statement {
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.main.arn}/*"]

    principals {
      type = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.main.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.main.json
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "aws_cloudfront_public_key" "main" {
  name = local.name_prefix
  encoded_key = tls_private_key.main.public_key_pem
}

resource "aws_cloudfront_key_group" "main" {
  name = local.name_prefix
  items = [aws_cloudfront_public_key.main.id]
}

resource "aws_cloudfront_distribution" "main" {
  comment = local.name_prefix
  enabled = true
  price_class = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket.main.bucket_regional_domain_name
    origin_id = aws_s3_bucket.main.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    compress = true
    target_origin_id = aws_s3_bucket.main.id
    viewer_protocol_policy = "redirect-to-https"
    trusted_key_groups = [aws_cloudfront_key_group.main.id]
    min_ttl = 0
    default_ttl = 86400
    max_ttl = 31536000

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern = "public/*"
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    compress = true
    target_origin_id = aws_s3_bucket.main.id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 86400
    max_ttl = 31536000

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
