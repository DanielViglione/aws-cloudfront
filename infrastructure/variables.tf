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
// variable "environment" {
//   type          = string
//   description   = "environment"
// }

// variable "product" {
//   type          = string
//   description   = "product"
// }

// variable "owner_name" {
//   type          = string
//   description   = "owner name"
// }

// variable "owner_contact" {
//   type          = string
//   description   = "owner contact"
// }

// variable "runbook_url" {
//   type          = string
//   description   = "runbook url"
// }

// variable "data_classification" {
//   type          = string
//   description   = "data classification"
// }

// variable "cost_center" {
//   type          = string
//   description   = "cost center"
// }

// variable "terraform_path" {
//   type        = string
//   description = "The terraform path this module was deployed from. Typically, use the path_relative_to_include() terragrunt function."
// }

// variable "tags" {
//   type        = map(string)
//   description = "Additional tags to add to all resources."
//   default     = {}
// }

