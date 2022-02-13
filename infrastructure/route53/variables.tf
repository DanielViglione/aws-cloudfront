variable "region" {
  type          = string
  description   = "region"
}

variable "domain_name" {
  type          = string
  description   = "domain name"
}

variable "cloudfront_distribution" {
  type          = string
  description   = "cloudfront domain"
}

variable "cloudfront_hosted_zone_id" {
  type          = string
  description   = "cloudfront hosted zone id"
}

variable "hosted_zone_name" {
  type          = string
  description   = "hosted zone name"
}
