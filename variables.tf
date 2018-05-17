variable "namespace" {
  description = "Namespace for configuration"
}

variable "instance_type" {
  description = "EC2 instance type (default: t2.nano)"
  default     = "t2.nano"
}

variable "subnet_id" {
  description = "Subnet ID to deploy within"
}

variable "security_group_id" {
  description = "Security group ID to use"
}
