data "aws_s3_bucket" "website_root" {
  bucket    = var.website_root_bucket
}

data "aws_s3_bucket" "website_logs" {
  bucket    = var.website_logs_bucket
}

// Instead of exposing your S3 bucket publicly to allow CloudFront to download objects, 
// it is best to keep your bucket private using CloudFront Origin Access Identity (OAI). 
// OAI is a special CloudFront user that is associated with an S3 origin and given the 
// necessary permissions to access to objects within the bucket. Currently, OAI only 
// supports SSE-S3, which means customers cannot use SSE-KMS with OAI.

// require you use SSE-KMS encryption on your S3 buckets and use CloudFront to deliver objects.
// Lambda@Edge functions are given IAM permissions to read from S3 and indirectly operate encryption/decryption using a CMK managed by KMS. These functions are triggered every time CloudFront makes a request to S3, and sign the request with AWS Signature Version 4 by adding the necessary headers. This signed request allows CloudFront to retrieve your object encrypted with SSE-KMS.
// resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
//   comment   = "Origin id to access ${data.aws_s3_bucket.website_root.id}"
// }

resource "aws_cloudfront_distribution" "website_cdn_root" {
  enabled                     = true 
  price_class                 = "PriceClass_All"
  aliases                     = ["${var.region}-${var.domain_name}"] # required if using Route53 domain

  origin {
    origin_id                 = "origin-bucket-${data.aws_s3_bucket.website_root.id}"
    // terraform bucket_regional_domain_name attribute is not pulling the correct domain including the s3 region:
    // https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
    // https://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region
    // protocol://service-code.region-code.amazonaws.com
    // terraform is not pulling in the region-code!!!!
    domain_name               = "${data.aws_s3_bucket.website_root.bucket}.s3.${var.region}.amazonaws.com"
    // domain_name               = data.aws_s3_bucket.website_root.bucket_regional_domain_name

    // specify for Origin Access Identity only
    // s3_origin_config {
      // origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    // }
  }

  default_root_object         = "index.html"

  logging_config {
    bucket                  = data.aws_s3_bucket.website_logs.bucket_domain_name 
    # prefix                  = "${var.subdomain}.${data.aws_route53_zone.new.name}/"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "origin-bucket-${data.aws_s3_bucket.website_root.id}"
    min_ttl          = "0"
    default_ttl      = "300"
    max_ttl          = "1200"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      headers      = ["Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers"]
      
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

  viewer_certificate {
    acm_certificate_arn = var.certificate_arn
    ssl_support_method  = "sni-only"
  }
  # viewer_certificate {
  #   cloudfront_default_certificate = true
  # }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 404
    response_page_path    = "/index.html"
    response_code         = 200
  }

  # when opening react app with url segment e.g. /send-receive, cloudfront returns 403.
  # Here we force it to 200 ok
  custom_error_response {
    error_caching_min_ttl = 60
    error_code            = 403
    response_page_path    = "/index.html"
    response_code         = 200
  }

  # lambda edge
  # using lambda@edge cache behavior for cloudfront "Behaviors"
  ordered_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "origin-bucket-${data.aws_s3_bucket.website_root.id}"
    min_ttl          = "0"
    default_ttl      = "300"
    max_ttl          = "1200"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      headers      = ["Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers"]
      
      cookies {
        forward = "none"
      }
    }

    path_pattern     = "*" # lands into your cloudfront distribution

    lambda_function_association {
      event_type          = "origin-request" # this needs to be origin-request not viewer-request
      lambda_arn          = var.lambda_edge_qualified_arn
      include_body        = false
    }
  }

  // tags = var.tags

  lifecycle {
    ignore_changes = [
      tags,
      viewer_certificate,
    ]
  }
}

// below configuration is an s3 bucket policy to allow for origin access identity
// but for kms-encrypted bucket, we will not use origin access identity
// Also note this policy overwrites the bucket policy provisioned with the s3 bucket
// in aws-s3 catalog.
// data "aws_iam_policy_document" "website_root" {
//     version                             = "2012-10-17"

//     statement {
//         actions   = ["s3:GetObject"]
//         resources = ["${data.aws_s3_bucket.website_root.arn}/*"]

//         principals {
//             type        = "AWS"
//             identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
//         }
//     }
// }

// resource "aws_s3_bucket_policy" "website_root" {
//     bucket = data.aws_s3_bucket.website_root.id
//     policy = data.aws_iam_policy_document.website_root.json
// }