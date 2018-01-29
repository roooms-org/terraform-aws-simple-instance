variable "config_name" {
  description = "Unique configuration name"
}

variable "instance_type" {
  description = "EC2 instance type (default: t2.nano)"
  default     = "t2.nano"
}

variable "vpc_id" {
  description = "VPC ID to deploy within"
}
