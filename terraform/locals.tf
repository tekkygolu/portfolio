locals {
  website_bucket_name = "static-website-hosting-bucket-<<AWS_ACCOUNT_ID>>"
  files = fileset("../website/", "*")
  domain_name = "anjali.bio"
  subdomain = "www"
}