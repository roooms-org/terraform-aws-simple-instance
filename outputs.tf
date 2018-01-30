output "instance_public_dns" {
  description = "Public DNS addresses"
  value       = "${aws_instance.main.*.public_dns}"
}
