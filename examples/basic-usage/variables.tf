variable "name" {
  type          = string
  description   = "name"      
  default       = "scrapetorium"
}

variable "name_suffix" {
  type          = string
  description   = "name suffix"
  default       = "tst"
}

# bucket dependencies

variable "website_root_bucket_primary" {
  type          = string
  description   = "website root (this is the bucket hosting your website)"
  default       = "scrapetorium-website-react-tst-us-east-1"
}

variable "website_logs_bucket_primary" {
  type          = string
  description   = "website root logs (this is the bucket hosting the logs of your website)"
  default       = "scrapetorium-website-logs-tst-us-east-1"
}

variable "website_root_bucket_secondary" {
  type          = string
  description   = "website root (this is the bucket hosting your website)"
  default       = "scrapetorium-website-react-tst-us-west-2"
}

variable "website_logs_bucket_secondary" {
  type          = string
  description   = "website root logs (this is the bucket hosting the logs of your website)"
  default       = "scrapetorium-website-logs-tst-us-west-2"
}

## support public facing domain

variable "add_domain" {
  type          = bool
  description   = "add domain"
  default       = true
}

variable "domain_name" {
  type          = string
  description   = "domain name (applicable if add_domain set to true)"
  default       = "webclient.scrapetorium.com"
}

variable "certificate_name" {
  type          = string
  description   = "certificate name (applicable if add_domain set to true)"
  default       = "*.scrapetorium.com"
}

variable "route53_hosted_zone_name" {
  type          = string
  description   = "route53 hosted zone name (applicable if add_domain set to true)"
  default       = "scrapetorium.com"
}