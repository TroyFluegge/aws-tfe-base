output "privateip" {
  value = ["${aws_instance.tfe-server[*].private_ip}"]
}

output "publicip" {
  value = ["${aws_instance.tfe-server[*].public_ip}"]
}

output "publicdns" {
  value = ["${aws_instance.tfe-server[*].public_dns}"]
}

output "message" {
  value = <<EOF
  
  Please review /var/log/tf-user-data.log for userdata script logs.

  SSH Connection:
    ssh -i ~/.ssh/${var.environment_name}.pem ubuntu@${aws_instance.tfe-server[0].public_ip}

  TFE Setup URL:
    https://${aws_instance.tfe-server[0].public_dns}:8800

  External Component Settings:
    S3 Bucket Name:     ${aws_s3_bucket.tfe-bucket.bucket}
    Database Hostname:  ${aws_db_instance.tfe.address}
    Database Name:      ${replace(var.environment_name, "-", "")}db
    Database Username:  ${var.dbusername}
    Database Password:  ${local.dbpassword}
EOF
}