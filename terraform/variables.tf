variable "appImage" {
  description   = "docker image to be deployed"
  type          = string
  default       = ""
}

variable "env" {
  description   = "environment to deploy to"
  type          = string
  default       = ""
}

variable "replicaCount" {
  description   = "desired amount of replicas"
  type          = number
  default       = 1
}

variable "appName" {
  description   = "app name"
  type          = string
  default       = ""
}

variable "environment" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "The environment variables to pass to the container. This is a list of maps. map_environment overrides environment"
  default     = []
}

variable containerCpu{
  description   = "amount of container cpu"
  type          = number
  default       = 128
}

variable containerMempry{
  description   = "amount of container memory"
  type          = number
  default       = 1024
}

variable "appPort" {
  description   = "port to be listened to by container"
  type          = number
  default       = "80"
}

variable "aws_region" {
  description   = "region to use for AWS resources"
  type          = string
  default       = "eu-central-1"
}

variable "cidr" {
  description   = "CIDR range for created VPC"
  type          = string
  default       = "10.0.0.0/16"
}