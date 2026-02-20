variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "instance_type" {
  description = "AWS instance type"
  type        = string
  default     = "t3.small"
}

variable "ip_public" {
  description = "Public IP allowed to SSH (CIDR)"
  type        = string
}

variable "key_name" {
  description	= "Key for SSH connection"
  type 		= string
}
