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

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.tpl")}"

  vars {
    pet_name = "${var.namespace}"
  }
}

resource "aws_instance" "main" {
  ami                         = "${data.aws_ami.amazon_linux.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = true
  user_data                   = "${data.template_file.user_data.rendered}"

  vpc_security_group_ids = [
    "${var.security_group_id}",
  ]

  tags {
    Name      = "${var.namespace}_aws_instance"
    Namespace = "${var.namespace}"
  }
}
