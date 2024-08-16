# Terraform Config file (main.tf). This has provider block (AWS) and config for provisioning one EC2 instance resource.  

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.27"
    }
  }

  required_version = ">=0.14"
}
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

data "terraform_remote_state" "public_subnet" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "prod-acs"                  // Bucket from where to GET Terraform State
    key    = "network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                 // Region where bucket created
  }
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
  name_prefix  = "${var.prefix}-${var.env}"

}

resource "aws_instance" "webserver1" {

  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.week7.key_name
  security_groups             = [aws_security_group.project-sg.id]
  subnet_id                   = data.terraform_remote_state.public_subnet.outputs.public_subnet_ids[0]
  associate_public_ip_address = true
  availability_zone           = "us-east-1a"
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(var.prefix)
    }
  )
  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-Webserver1"
    }
  )
}

resource "aws_instance" "webserver2" {

  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.week7.key_name
  security_groups             = [aws_security_group.project-sg.id]
  subnet_id                   = data.terraform_remote_state.public_subnet.outputs.public_subnet_ids[1]
  associate_public_ip_address = true
  availability_zone           = "us-east-1b"

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-Webserver2"
    }
  )
}

resource "aws_instance" "webserver3" {

  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.week7.key_name
  security_groups             = [aws_security_group.project-sg.id]
  subnet_id                   = data.terraform_remote_state.public_subnet.outputs.public_subnet_ids[2]
  associate_public_ip_address = true
  availability_zone           = "us-east-1c"


  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-Webserver3"
    }
  )
}

resource "aws_instance" "webserver4" {

  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.week7.key_name
  security_groups             = [aws_security_group.project-sg.id]
  subnet_id                   = data.terraform_remote_state.public_subnet.outputs.public_subnet_ids[3]
  associate_public_ip_address = true
  availability_zone           = "us-east-1d"


  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-Webserver4"
    }
  )
}

resource "aws_instance" "webserver5" {

  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.week7.key_name
  security_groups             = [aws_security_group.project-sg.id]
  subnet_id                   = data.terraform_remote_state.public_subnet.outputs.private_subnet_ids[0]
  associate_public_ip_address = false
  availability_zone           = "us-east-1a"
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(var.prefix)
    }
  )

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-Webserver5"
    }
  )
}

resource "aws_instance" "vm6" {

  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.week7.key_name
  security_groups             = [aws_security_group.project-sg.id]
  subnet_id                   = data.terraform_remote_state.public_subnet.outputs.private_subnet_ids[1]
  associate_public_ip_address = false
  availability_zone           = "us-east-1b"
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(var.prefix)
    }
  )

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-VM6"
    }
  )
}

# Adding SSH  key to instance
resource "aws_key_pair" "week7" {
  key_name   = var.prefix
  public_key = file("${var.prefix}.pub")
}

#security Group
resource "aws_security_group" "project-sg" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.public_subnet.outputs.vpc_id

  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-EBS"
    }
  )
}


# Define Application Load Balancer
resource "aws_lb" "app_lb" {
  name                       = "${var.prefix}-app-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.project-sg.id]
  subnets                    = data.terraform_remote_state.public_subnet.outputs.public_subnet_ids
  enable_deletion_protection = false

  enable_cross_zone_load_balancing = true

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-app-lb"
    }
  )

  depends_on = [aws_instance.webserver1, aws_instance.webserver2, aws_instance.webserver3]
}

# Define Target Group
resource "aws_lb_target_group" "app_target_group" {
  name     = "${var.prefix}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.public_subnet.outputs.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-target-group"
    }
  )

  depends_on = [aws_instance.webserver1, aws_instance.webserver2, aws_instance.webserver3]
}

# Define Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }

  depends_on = [aws_lb.app_lb, aws_lb_target_group.app_target_group]
}


# Attach EC2 Instances to Target Group
resource "aws_lb_target_group_attachment" "webserver1_attachment" {
  target_group_arn = aws_lb_target_group.app_target_group.arn
  target_id        = aws_instance.webserver1.id
  port             = 80

  depends_on = [aws_instance.webserver1, aws_lb_target_group.app_target_group]
}

resource "aws_lb_target_group_attachment" "webserver2_attachment" {
  target_group_arn = aws_lb_target_group.app_target_group.arn
  target_id        = aws_instance.webserver2.id
  port             = 80

  depends_on = [aws_instance.webserver2, aws_lb_target_group.app_target_group]
}

resource "aws_lb_target_group_attachment" "webserver3_attachment" {
  target_group_arn = aws_lb_target_group.app_target_group.arn
  target_id        = aws_instance.webserver3.id
  port             = 80

  depends_on = [aws_instance.webserver3, aws_lb_target_group.app_target_group]
}
