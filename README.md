# Terraform Enterprise Foundational Infrastructure

Builds Terraform Enterprise foundational prerequisites in AWS. Follow the instructions at the setup URL to complete the installation. The outputs from this Terraform can be used as inputs to the external component settings.

Add your airgap file to \airgap. Use the default `tfe.airgap` filename or define your own in your tfvars file.

## Commands
```
terraform init
terraform plan # verify updates
teraform apply --auto-approve # yolo
```

## Outputs:
### Userdata Script Log

`/var/log/tf-user-data.log`
### SSH Connection:
```ssh -i ~/.ssh/{{cert}}.pem ubuntu@{{public_ip}}```

### TFE Setup URL:
```https://{{public_dns}}:8800```

### External Component Settings:
```
    S3 Bucket Name:     {{statefile_bucket}}
    Database Hostname:  {{rds_dns_hostname}}
    Database Name:      {{rds_db_name}}
    Database Username:  {{rds_username}}
    Database Password:  {{rds_password}}
```