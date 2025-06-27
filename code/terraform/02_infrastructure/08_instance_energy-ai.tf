module "energy-ai" {
  source                   = "../modules/instance_v2"
  instance_count           = 1
  instance_name            = "energy-ai"
  instance_key_pair        = "default_key"
  instance_security_groups = ["ssh-internal", "all_internal", "node_exporter", "web"]
  instance_network_internal = var.network_internal_dev
  instance_ssh_key         = var.ssh_public_key_default_user
  public_floating_ip       = false
  instance_default_user    = var.default_user
  
  # Plus de ressources pour IA/ML
  instance_flavor_name     = "m1.medium"  # Au lieu de m1.small
  
  # Add volume configuration
  instance_volumes_count   = 1            # Number of volumes to attach
  instance_volumes_size    = 50           # Size in GB (adjust as needed)
  instance_volumes_type    = "lvm-1"      # Volume type
  
  metadatas = {
    environment = "dev",
    app         = "energy-ai",
    role        = "intelligence"
  }
}