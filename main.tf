data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.selected.id}"

  tags {
    Config_Name = "${var.config_name}"
    Tier        = "public"
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.tpl")}"

  vars {
    pet_name = "${random_pet.main.id}"
  }
}

resource "random_pet" "main" {
  keepers = {
    config_name = "${var.config_name}"
  }
}

resource "aws_instance" "main" {
  ami                         = "${data.aws_ami.amazon_linux.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(data.aws_subnet_ids.public.ids, count.index)}"
  associate_public_ip_address = true
  user_data                   = "${data.template_file.user_data.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.main.id}",
  ]

  tags {
    Name        = "${var.config_name}_aws_instance"
    Config_Name = "${var.config_name}"
  }
}

resource "aws_security_group" "main" {
  name        = "${var.config_name}_aws_security_group_public"
  description = "${var.config_name}_aws_security_group_public"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.config_name}_aws_security_group_public"
    Config_Name = "${var.config_name}"
  }
}
