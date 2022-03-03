variable "region" {
  type          = string
  description   = "region"
}

variable "website_root_bucket" {
  type          = string
  description   = "website root bucket"
}

variable "website_logs_bucket" {
  type          = string
  description   = "website root bucket"
}

# ---------------------------------------------------------------------------------------------------------------------
# Route53
# These variables are used for Route53.
# ---------------------------------------------------------------------------------------------------------------------

variable "add_domain" {
  type          = bool
  description   = "add domain"
}

variable "domain_name" {
  type          = string
  description   = "domain name"
}

variable "certificate_arn" {
  type          = string
  description   = "certificate arn"
}

variable "hosted_zone_name" {
  type          = string
  description   = "hosted zone name"
}

# ---------------------------------------------------------------------------------------------------------------------
# Lambda Edge
# These variables are used for Lambda Edge.
# ---------------------------------------------------------------------------------------------------------------------

variable "lambda_edge_role_arn" {
  type          = string
  description   = "lambda edge role arn"
}

variable "function_qualified_arn" {
  type          = string
  description   = "function qualified arn"
}

# ---------------------------------------------------------------------------------------------------------------------
# TAGGING
# These variables are used in tagging.
# ---------------------------------------------------------------------------------------------------------------------