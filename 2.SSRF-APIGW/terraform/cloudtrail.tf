resource "aws_cloudtrail" "cr-ssrf-ct" {
  depends_on = [aws_s3_bucket_policy.cr-ssrf-bucket-policy]

  name                          = "cr-ssrf-ct"
  s3_bucket_name                = aws_s3_bucket.cr-ssrf-bucket.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
}

resource "aws_s3_bucket" "cr-ssrf-bucket" {
  bucket        = "cr-ssrf-bucket"
  force_destroy = true
}

data "aws_iam_policy_document" "cr-ssrf-ct-policy" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cr-ssrf-bucket.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/cr-ssrf-ct"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cr-ssrf-bucket.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/cr-ssrf-ct"]
    }
  }
}

resource "aws_s3_bucket_policy" "cr-ssrf-bucket-policy" {
  bucket = aws_s3_bucket.cr-ssrf-bucket.id
  policy = data.aws_iam_policy_document.cr-ssrf-ct-policy.json
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}