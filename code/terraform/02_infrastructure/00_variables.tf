variable "network_external_id" {
  type    = string
  default = "08627590-0aac-4168-ba4f-7b00fade2514"
}

variable "network_external_name" {
  type    = string
  default = "ext-floating1"
}

variable "network_internal_dev" {
  type    = string
  default = "internal_dev"
}

variable "default_user" {
  type    = string
  default = "staner"
}

variable "network_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "ssh_public_key_default_user" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCkmUQVaIHRxoukQftYJJjuPf1an104jLltRlN0y8xAsVQ+OXIvORbaYvHwbry4PXQXUZYnFDOX/ybl6wAI5Lxt7STe2xUY7mYrBCn1+lfirB1LnlOKDEDQGndXQPUrH1CbUbZw7MxXAVif+I1iPlf4pgXlic1i7FigQiRS2bMkiVrbtkXufGnNgbOar0iaLKdFuYNERk/WJSjIz7HPoljqULWctXzqpFDXPs/GKKPbH96iH0SFLTDG5tCMN424saAnkAcFcGsW0BqVpLBSBUCcySoaKcWgGYqHB+OPRa50NqZ2ljuopIvQMFA4Otg6dcDWshklP265NHddB3QWs3t/JQvDYGe7Ld8i4eQtMFsNNL0R6E8XOYT8hAb75K4H77SACU+BGAmwHGC13IFhTWRct5KC+wskYi/J9zmslugk9jQcoPwIFdMA9nkzOWPIMwMYM4A+BxL8ne4unP8786Zemuyft8lE/Q3SOFg8SV+UjRjlsL+EfrCIngEZLnUzj/gpNZLGi+En3qm3mZhIsoC55KW4lutlZwnXnpU3swJ9wR/LKJtup5UcVx2pRDmwLzW20WI46fF2/HLMHWlpWuK/r0N5nEg7BMB3B4j1KLqkTljN9Fu5OMyCNBN/M8pyoFqf7TQaP0OsGcBzVvx1i3oUTVqQwAriBr2hYe6L6Z1lnQ== staner@staner-home"
}

variable "instance_image_id" {
  type    = string
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

variable "metadatas" {
  type = map(string)
  default = {
    "environment" = "dev"
  }
}

variable "ANSIBLE_ENV_VARS" {
  type = string
  default = "ANSIBLE_CONFIG=../../ansible/ansible.cfg ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_password.yml"
}
variable "ANSIBLE_COMMAND" {
  type = string
  default = "ansible-playbook -u"
}
variable "ANSIBLE_OPTIONS" {
  type = string
  default = "-i ../../ansible/envs/dev/openstack.yml --private-key ~/.ssh/id_rsa"
}
