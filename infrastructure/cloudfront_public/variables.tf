variable "region" {
  type        = string
  description = "region"
}

variable "domain_name" {
  type        = string
  description = "domain name"
}

variable "certificate_arn" {
  type        = string
  description = "certificate arn"
}

variable "website_root_bucket" {
  type        = string
  description = "website root bucket"
}

variable "website_logs_bucket" {
  type        = string
  description = "website logs bucket"
}

variable "lambda_edge_qualified_arn" {
  type        = string
  description = "lambda edge arn"
}

// variable "tags" {
//   type        = map(string)
//   description = "tags"
// }