variable "domain_name" {
  type        = string
  description = "domain name"
}

variable "certificate_name" {
  type        = string
  description = "certificate name"
}

variable "website_root_bucket_primary" {
  type        = string
  description = "website root bucket primary"
}

variable "website_logs_bucket_primary" {
  type        = string
  description = "website logs bucket primary"
}

variable "website_root_bucket_secondary" {
  type        = string
  description = "website root bucket secondary"
}

variable "website_logs_bucket_secondary" {
  type        = string
  description = "website logs bucket secondary"
}

variable "lambda_edge_qualified_arn" {
  type        = string
  description = "lambda edge arn"
}

// variable "tags" {
//   type        = map(string)
//   description = "tags"
// }