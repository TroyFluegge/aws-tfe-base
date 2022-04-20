resource "aws_db_subnet_group" "tfe" {
    name = var.environment_name
    subnet_ids = module.vpc.private_subnets

    tags = merge(var.default_base_tags, {
    Name = "${var.environment_name}-dbsn-group"
  })
}

# Random password for the RDS database
resource "random_string" "password" {
  length           = 30
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  dbpassword = random_string.password.result
}

resource "aws_db_instance" "tfe" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = "db.m6g.large"
  db_name              = "${replace(var.environment_name, "-", "")}db"
  identifier           = var.environment_name
  username             = var.dbusername
  password             = local.dbpassword
  db_subnet_group_name = aws_db_subnet_group.tfe.name
  vpc_security_group_ids = [aws_security_group.tfe-sg.id]
  skip_final_snapshot  = true
  backup_retention_period = "0"
  
  tags = merge(var.default_base_tags, {
    Name = "${var.environment_name}-db"
  })
}