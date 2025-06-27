module "minio" {
  source                   = "../modules/instance_v2"
  instance_count           = 1
  instance_name            = "minio"
  instance_key_pair        = "default_key"
  instance_security_groups = ["ssh-internal", "all_internal", "node_exporter", "minio"]
  instance_network_internal = var.network_internal_dev
  instance_ssh_key         = var.ssh_public_key_default_user
  public_floating_ip       = false
  instance_default_user    = var.default_user
  instance_volumes_count   = 1
  instance_flavor_name     = "m1.medium"  # MinIO a besoin de plus de ressources
  metadatas = {
    environment = "dev",
    app         = "minio"
  }
}