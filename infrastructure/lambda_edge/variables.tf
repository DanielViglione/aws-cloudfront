variable "name_prefix" {
  type          = string
  description   = "name prefix"
}

variable "name_suffix" {
  type          = string
  description   = "name suffix"
}

variable "add_domain" {
  type        = bool
  description = "add domain"
}

variable "domain" {
  type        = string
  description = "domain"
}

// variable "permissions_boundary_arn" {
//   type          = string
//   description   = "permissions boundary arn"
// }

# ---------------------------------------------------------------------------------------------------------------------
# Lambda Edge
# These variables are used for Lambda Edge.
# ---------------------------------------------------------------------------------------------------------------------

variable "timeout" {
  type        = number
  description = "timeout"
  default     = 3
}

variable "memory_size" {
  type        = number
  description = "memory size"
  default     = 128
}

# ---------------------------------------------------------------------------------------------------------------------
# TAGGING
# These variables are used in tagging.
# ---------------------------------------------------------------------------------------------------------------------
// variable "environment" {
//   type        = string 
//   description = "environment"
// }

// variable "product" {
//   type        = string 
//   description = "product"
// }

// variable "owner_name" {
//   type        = string 
//   description = "owner name"
// }

// variable "owner_contact" {
//   type        = string 
//   description = "owner contact"
// }

// variable "runbook_url" {
//   type        = string 
//   description = "runbook url"
// }

// variable "data_classification" {
//   type        = string 
//   description = "data classification"
// }

// variable "cost_center" {
//   type        = string 
//   description = "cost center"
// }

// variable "terraform_path" {
//   type        = string 
//   description = "terraform path"
//   default     = ""
// }

// variable "custom_tags" {
//   type        = map(string)
//   description = "custom tags"
//   default     = {}
// }