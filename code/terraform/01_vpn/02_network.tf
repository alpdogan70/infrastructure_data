resource "openstack_networking_router_v2" "rt1" {
  name                = "rt1"
  admin_state_up      = "true"
  external_network_id = var.network_external_id
}

#locals {
#  k8s_masters = ["10.0.1.101","10.0.1.102","10.0.1.103"]
#}
#
#resource "openstack_networking_router_route_v2" "k8s_pods_routes" {
#  for_each = toset(local.k8s_masters)
#  router_id        = openstack_networking_router_v2.rt1.id
#  destination_cidr = "10.200.0.0/16"
#  next_hop         = "${each.key}"
#  depends_on       = [openstack_networking_router_v2.rt1]
#}
#
#resource "openstack_networking_router_route_v2" "k8s_services_routes" {
#  for_each = toset(local.k8s_masters)
#  router_id        = openstack_networking_router_v2.rt1.id
#  destination_cidr = "10.201.0.0/16"
#  next_hop         = "${each.key}"
#  depends_on       = [openstack_networking_router_v2.rt1]
#}

module "network_dev" {
  source          = "../modules/network"
  network_name		= var.network_internal_dev
  network_subnet_cidr	= var.network_subnet_cidr
  router_id		= openstack_networking_router_v2.rt1.id
}
