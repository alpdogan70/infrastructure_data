
module "k8sm" {
  source                      = "../modules/instance_v2"
  instance_count              = 2
  instance_name               = "k8sm"
  instance_key_pair           = "default_key"
  instance_security_groups    = ["ssh-internal", "all_internal", "k8s_internal_pods", "k8s_internal_services"]
  instance_network_internal   = var.network_internal_dev
  instance_ssh_key = var.ssh_public_key_default_user
  instance_default_user = var.default_user
  instance_flavor_name        = "m2.large"
  instance_internal_fixed_ip = "10.0.1.10"
  allowed_addresses           = ["10.200.0.0/16","10.201.0.0/16"]
  metadatas                   = {
    environment          = "dev",
    app         = "k8sm"
  }
}
      