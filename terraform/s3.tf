resource "aws_s3_bucket" "website_bucket" {
  bucket = local.website_bucket_name

  tags = {
    Name        = local.website_bucket_name
    Environment = "Dev"
  }
}


resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_access_from_public_internett" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.website_bucket.arn}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${resource.aws_cloudfront_distribution.s3_distribution.arn}"
                }
            }
        }
    ]
}
EOF
}

resource "null_resource" "get_mime_type" {
  for_each = local.files

  provisioner "local-exec" {
    command = " file --mime-type -b ../website/${each.value} > ../website/mimes/${each.value}.txt"
  }
}

resource "aws_s3_bucket_object" "website_files" {
  for_each = local.files

  bucket = aws_s3_bucket.website_bucket.bucket
  key    = each.value
  source = "../website/${each.value}"
  content_type = file("../website/mimes/${each.value}.txt")
  etag = filemd5("../website/${each.value}")
}