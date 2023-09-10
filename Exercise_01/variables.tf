variable "region" {
  type        = string
  description = "Name of region"
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "Id of default VPC"
  default     = null
}

variable "vpc_security_group_ids" {
  type        = set(string)
  description = "Ids of default VPC Security Group"
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "Id of default subnet"
  default     = null
}

variable "ec2_t2_name" {
  type        = string
  description = "Name of Udacity T2"
  default     = null
}

variable "ec2_t2_instance_type" {
  type        = string
  description = "Instance type of EC2 T2"
  default     = null
}

variable "ec2_m4_name" {
  type        = string
  description = "Name of Udacity M4"
  default     = null
}

variable "ec2_m4_instance_type" {
  type        = string
  description = "Instance type of EC2 M4"
  default     = null
}
