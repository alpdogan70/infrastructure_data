
#module "monitoring" {
#  source                      = "../modules/instance_v2"
#  instance_count              = 1
#  instance_name               = "monitoring"
#  instance_key_pair           = "default_key"
#  instance_security_groups    = ["ssh-internal", "all_internal", "node_exporter"]
#  instance_network_internal   = var.network_internal_dev
#  instance_ssh_key = var.ssh_public_key_default_user
#  instance_default_user = var.default_user
#  instance_flavor_name        = "m2.large"
#  instance_volumes_count = 2
#  metadatas                   = {
#    environment          = "dev",
#    app         = "monitoring"
#  }
#}
      