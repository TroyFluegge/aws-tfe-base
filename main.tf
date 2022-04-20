provider "aws" {
  region = var.aws_region
}

resource "tls_private_key" "tfe" {
  algorithm = "RSA"
}

resource "aws_key_pair" "tfe" {
  key_name   = var.environment_name
  public_key = tls_private_key.tfe.public_key_openssh
}

resource "null_resource" "tfe" {
  provisioner "local-exec" {
    command = "echo '${tls_private_key.tfe.private_key_pem}' > ~/.ssh/${var.environment_name}.pem && chmod 600 ~/.ssh/${var.environment_name}.pem"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

//--------------------------------------------------------------------
// TFE Server Instance

resource "aws_instance" "tfe-server" {
  count                       = length(var.tfe_server_names)
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  availability_zone           = var.availability_zones[count.index]
  subnet_id                   = module.vpc.public_subnets[count.index]
  key_name                    = var.environment_name
  vpc_security_group_ids      = [aws_security_group.tfe-sg.id]
  private_ip                  = var.tfe_server_private_ips[count.index]
  iam_instance_profile        = aws_iam_instance_profile.tfe-server.id
  associate_public_ip_address = true
  tags = merge(var.default_base_tags, {
    Name = "${var.environment_name}-${var.tfe_server_names[count.index]}"
  })

  root_block_device {
    volume_size           = 50
  }

  user_data = templatefile("${path.module}/templates/userdata-server.tpl", {
    tpl_server_count_index        = count.index
  })

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("~/.ssh/${var.environment_name}.pem")}"
    host     = self.public_ip
  }

  provisioner "file" {
    source      = "airgap/${var.airgap_file}"
    destination = "/home/ubuntu/${var.airgap_file}"
  }

  lifecycle {
    ignore_changes = [ami, tags]
  }
}