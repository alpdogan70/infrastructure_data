variable "instance_network_external_name" {
  type    = string
  default = ""
}

variable "instance_network_external_id" {
  type = string
  default = ""
}

variable "instance_name" {
  type = string
}

variable "instance_image_id" {
  type = string
  default = "4b370c45-fc98-4dab-88ee-22e09bb57679"
}

variable "instance_flavor_name" {
  type    = string
  default = "m1.small"
}

variable "instance_security_groups" {
  type    = list(any)
  default = ["default"]
}

variable "instance_key_pair" {
  type = string
}

variable "metadatas" {
  type = map(string)
  default = {
    "environment" = "dev"
  }
}

variable "instance_ssh_key" {
  type = string
}

variable "instance_network_internal" {
  type    = string
}

variable "instance_count" {
  type = number
  default = 1
}

variable "public_floating_ip" {
  type = bool
  default = false
}

variable "public_floating_ip_fixed" {
  type = string
  default = ""
}


variable "instance_default_user" {
  type = string
  default = ""
}

variable "instance_internal_fixed_ip" {
  type = string
  default = ""
}

variable "instance_volumes_count" {
  type = number
  default = 0
}

variable "instance_volumes_size" {
  type = number
  default = 20
}

variable "instance_volumes_type" {
  type = string
  default = "lvm-1"
}

variable "allowed_addresses" {
  type = list
  default = []
}