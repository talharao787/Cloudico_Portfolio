variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "The AWS region to deploy the database to."
}

variable "product" {
  type        = string
  description = "The product name."
}

variable "component" {
  type        = string
  description = "The component name."
}

variable "environment" {
  type        = string
  description = "The environment name."
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID to deploy the database to."
}

variable "subnet_ids" {
  type        = list(string)
  description = "The subnet IDs to deploy the database to."
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks to allow ingress from."
}

variable "pg_version" {
  type        = string
  description = "The PostgreSQL version to use."
}

variable "scaling_max_capacity" {
  description = "The maximum compute capacity of the database."
  type        = number
  default     = 4
}

variable "scaling_min_capacity" {
  description = "The minimum compute capacity of the database."
  type        = number
  default     = 0.5
}
