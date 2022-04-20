# TFE Foundational Infrastructure

Builds the foundational prerequisites in AWS.

Instance userdata logs will be created here
/var/log/tf-user-data.log

Outputs:
  SSH Connection:
    ssh -i ~/.ssh/{{cert}}.pem ubuntu@{{public_ip}}

  TFE Setup URL:
    https://{{public_dns}}:8800

  External Component Settings:
    S3 Bucket Name:     {{statefile_bucket}}
    Database Hostname:  {{rds_dns_hostname}}
    Database Name:      {{rds_db_name}}
    Database Username:  {{rds_username}}
    Database Password:  {{rds_password}}