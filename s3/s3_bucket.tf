resource "aws_s3_bucket" "mngmt_tf_states" {
  bucket = var.bucket_name

  tags = {
    Name    = var.bucket_name
    Account = var.account_id
    Owner   = var.owner
  }

}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.mngmt_tf_states.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "mngmt_tf_states_policy" {
  bucket = aws_s3_bucket.mngmt_tf_states.id
  policy = data.aws_iam_policy_document.mngmt_tf_states_policy.json
}

data "aws_iam_policy_document" "mngmt_tf_states_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [for s in var.allowed_roles : "arn:aws:iam::${var.account_id}:user/${s}"]
    }

    actions = [for s in var.actions : "s3:${s}"]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/*",
      "arn:aws:s3:::${var.bucket_name}",
    ]
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.mngmt_tf_states.bucket

  rule {
    id = "tfstate"
    filter {
      prefix = "tfstate/"
    }
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
  expected_bucket_owner = var.account_id
}