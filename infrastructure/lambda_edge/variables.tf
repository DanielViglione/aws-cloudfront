variable "name_prefix" {
  type          = string
  description   = "name prefix"
}

variable "name_suffix" {
  type          = string
  description   = "name suffix"
}

# ---------------------------------------------------------------------------------------------------------------------
# Lambda Edge
# These variables are used for Lambda Edge.
# ---------------------------------------------------------------------------------------------------------------------

variable "filename" {
  type          = string
  description   = "filename" 
  default       = "sigv4_request_to_s3_role.zip"
}

variable "source_code_hash" {
  type          = string
  description   = "source code hash"
}

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

// variable "permissions_boundary_arn" {
//   type          = string
//   description   = "permissions boundary arn"
// }

// variable "tags" {
//   type          = string
//   description   = "tags"
// }

# ---------------------------------------------------------------------------------------------------------------------
# TAGGING
# These variables are used in tagging.
# ---------------------------------------------------------------------------------------------------------------------