# Bucket for Terraform State Files
resource "aws_s3_bucket" "tfe-bucket" {
  bucket = "${var.environment_name}-state"
  tags = merge(var.default_base_tags, {
    Name = "${var.environment_name}-state"
  })
}