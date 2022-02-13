variable "region" {
  type        = string
  description = "region"
}

variable "website_root_bucket" {
  type        = string
  description = "website root bucket"
}

variable "website_logs_bucket" {
  type        = string
  description = "website logs bucket"
}

// variable "tags" {
//   type        = map(string)
//   description = "tags"
// }