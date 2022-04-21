# AWS EC2 Region
# default: 'us-east-1'
# @see https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions
aws_region = "us-east-2"

# AWS EC2 Availability Zone
# default: "us-east-1a", "us-east-1b", "us-east-1c"
# @see https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#using-regions-availability-zones-launching
availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

# Name of the TFE airgap file
# Default: tfe.airgap
airgap_file = "addyour.airgap"

# Mandatory Base Tags
default_base_tags = {
  owner   = "FirstName LastName"
  contact = "me@mydomain.com"
  TTL     = "-1"
}