variable "region" {
  description = "AWS region"
  default     = "eu-north-1"
}


variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}


variable "pubsub" {
  description = "List of CIDRs for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}


variable "privsub" {
  description = "CIDR blocks for private subnets"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "k3s_token" {
  description = "K3s cluster token"
  type        = string
}

