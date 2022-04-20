//--------------------------------------------------------------------
// Resources

## tfe Server IAM Config
resource "aws_iam_instance_profile" "tfe-server" {
  name = "${var.environment_name}-instance-profile"
  role = aws_iam_role.tfe-server.name
}

resource "aws_iam_role" "tfe-server" {
  name               = "${var.environment_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "tfe-server" {
  name   = "${var.environment_name}-role-policy"
  role   = aws_iam_role.tfe-server.id
  policy = data.aws_iam_policy_document.tfe-server.json
}

//--------------------------------------------------------------------
// Data Sources

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Should narrow this policy down to the bucket
data "aws_iam_policy_document" "tfe-server" {
  statement {
    sid    = "S3TFEStateStorage"
    effect = "Allow"
    actions = [
      "s3:*",
    ]
    resources = ["*"]
  }
}