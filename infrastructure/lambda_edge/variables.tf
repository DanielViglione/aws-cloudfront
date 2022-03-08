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

variable "certificate_name" {
  type        = string
  description = "certificate_name"
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