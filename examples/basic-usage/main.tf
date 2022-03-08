terraform {
  required_providers {
    aws = {
      version = "= 3.74.1"
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
}

provider "aws" {
  alias  = "secondary_region"
  region = "us-west-2"
}

resource "random_pet" "name_suffix" {
  length = 2
}

############ AWS Bootstrap ############
# creates vpc, subnets, nacls, etc from account_settings module
module "bootstrap" {
  source = "git::git@github.com:Infinite-Limit-Data-Science-LLC/aws-bootstrap.git?ref=v1.1"
}

############ CDN Service ############

# create only a primary since
# cloudfront is a global resource
module "cloudfront_primary" {
  source                          = "../../infrastructure"
  name_prefix                     = var.name_prefix
  name_suffix                     = var.name_suffix
  website_root_bucket_primary     = var.website_root_bucket_primary
  website_logs_bucket_primary     = var.website_logs_bucket_primary
  website_root_bucket_secondary   = var.website_root_bucket_secondary
  website_logs_bucket_secondary   = var.website_logs_bucket_secondary
  add_domain                      = var.add_domain
  domain_name                     = var.domain_name
  certificate_name                = var.certificate_name
  hosted_zone_name                = var.route53_hosted_zone_name

  // environment               = module.account_settings.environment
  // product                   = module.account_settings.product
  // owner_name                = module.account_settings.owner_name
  // owner_contact             = module.account_settings.owner_contact
  // runbook_url               = module.account_settings.runbook_url
  // data_classification       = module.account_settings.data_classification
  // cost_center               = module.account_settings.cost_center
  // terraform_path            = var.name

  providers = {
     aws = "aws"
  }
}

resource "null_resource" "publish_primary_image" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    interpreter       = ["bash", "-c"]
    command           = "${abspath("../../")}/initialize.sh ${var.website_root_bucket_primary}"
  }
}

resource "null_resource" "publish_secondary_image" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    interpreter       = ["bash", "-c"]
    command           = "${abspath("../../")}/initialize.sh ${var.website_root_bucket_secondary}"
  }
}