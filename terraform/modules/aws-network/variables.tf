# Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

variable "aws_vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
  default     = "172.2.0.0/16"
}

variable "private_subnet_1_cidr_block" {
  description = "VPC CIDR range"
  type        = string
  default     = "172.2.1.0/24"
}

variable "private_subnet_2_cidr_block" {
  description = "VPC CIDR range"
  type        = string
  default     = "172.2.2.0/24"
}

variable "public_subnet_1_cidr_block" {
  description = "VPC CIDR range"
  type        = string
  default     = "172.2.3.0/24"
}

variable "public_subnet_2_cidr_block" {
  description = "VPC CIDR range"
  type        = string
  default     = "172.2.4.0/24"
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "demo-java-app"
}

variable "availability_zone_1" {
  description = "VPC CIDR range"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "VPC CIDR range"
  type        = string
  default     = "us-east-1c"
}

variable "vpc_endpoint_sg_name" {
  description = "VPC Endpoint SG name"
  type        = string
  default     = "allow_tls_vpc_endpoint_sg"
}