module "traefik" {
  source                      = "../modules/instance_v2"
  instance_count              = 1
  instance_name               = "traefik"
  instance_key_pair           = "default_key"
  instance_security_groups    = ["all_internal","proxy","gitlab-ssh"]
  instance_network_internal   = var.network_internal_dev
  instance_ssh_key = var.ssh_public_key_default_user
  instance_default_user = var.default_user
  instance_network_external_name = var.network_external_name
  instance_network_external_id  = var.network_external_id
  public_floating_ip = true
  public_floating_ip_fixed = "192.168.50.244"
  metadatas                   = {
    environment          = "dev",
    app         = "proxy"
  }
}
