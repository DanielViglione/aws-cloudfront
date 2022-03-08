variable "name_prefix" {
  type          = string
  description   = "name prefix"
}

variable "name_suffix" {
  type          = string
  description   = "name suffix"
}

variable "website_root_bucket_primary" {
  type          = string
  description   = "website root bucket primary"
}

variable "website_logs_bucket_primary" {
  type          = string
  description   = "website logs bucket primary"
}

variable "website_root_bucket_secondary" {
  type          = string
  description   = "website root bucket secondary"
}

variable "website_logs_bucket_secondary" {
  type          = string
  description   = "website logs bucket secondary"
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

variable "certificate_name" {
  type          = string
  description   = "certificate arn"
}

variable "hosted_zone_name" {
  type          = string
  description   = "hosted zone name"
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

