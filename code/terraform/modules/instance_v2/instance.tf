data "template_file" "userdata" {
  template = <<CLOUDCONFIG
#cloud-config
users:
  - default
  - name: ${var.instance_default_user}
    primary_group: ${var.instance_default_user}
    groups: [sudo,adm]
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    lock_passwd: true
    ssh-authorized-keys: 
    - ${var.instance_ssh_key}
CLOUDCONFIG
}

data "openstack_networking_network_v2" "network" {
  name = var.instance_network_internal
}

data "openstack_networking_secgroup_v2" "sg" {
  for_each = toset(var.instance_security_groups)
  name = "${each.key}"
}

locals {
  secgroup_list = [ for sg in data.openstack_networking_secgroup_v2.sg: sg.id ]
}

data "openstack_networking_subnet_v2" "subnet" {
  name = var.instance_network_internal
}

resource "openstack_networking_port_v2" "internal_port" {
  count      = var.instance_count
  name       = "internal-${var.instance_name}${count.index + 1}"
  network_id = data.openstack_networking_network_v2.network.id
  port_security_enabled = true

  security_group_ids = local.secgroup_list

  fixed_ip   {
    subnet_id = data.openstack_networking_subnet_v2.subnet.id 
    ip_address = var.instance_internal_fixed_ip == "" ? "" : "${var.instance_internal_fixed_ip}${count.index + 1}"
  }

  dynamic "allowed_address_pairs" {
    for_each = length(var.allowed_addresses) == 0 ? [] : var.allowed_addresses
    content {
      ip_address = allowed_address_pairs.value
    }
  }
}

data openstack_networking_port_v2 "port" {
  count      = var.instance_count
  name       = "internal-${var.instance_name}${count.index + 1}"

  depends_on = [ openstack_networking_port_v2.internal_port ]
}

data "openstack_networking_subnet_ids_v2" "ext_subnets" {
  count = var.public_floating_ip ? 1 : 0
  network_id = var.instance_network_external_id
}


resource "openstack_networking_floatingip_v2" "floatip_1_random" {
  count = var.public_floating_ip  && var.public_floating_ip_fixed == "" ? var.instance_count : 0
  pool       = data.openstack_networking_network_v2.network[count.index].name
  subnet_ids = data.openstack_networking_subnet_ids_v2.ext_subnets[count.index].ids
}

resource "openstack_compute_instance_v2" "instance" {
  count           = var.instance_count
  name            = "${var.instance_name}${count.index + 1}"
  image_id        = var.instance_image_id
  flavor_name     = var.instance_flavor_name
  metadata        = var.metadatas
  user_data = data.template_file.userdata.rendered
  security_groups = var.instance_security_groups
  key_pair        = var.instance_key_pair

  network {
    port = data.openstack_networking_port_v2.port[count.index].id
  }

  depends_on = [ openstack_networking_port_v2.internal_port ]

}

resource "openstack_compute_floatingip_associate_v2" "fip_assoc_random" {
  count = var.public_floating_ip && var.public_floating_ip_fixed == ""? var.instance_count : 0
  floating_ip = openstack_networking_floatingip_v2.floatip_1_random[count.index].address
  instance_id = openstack_compute_instance_v2.instance[count.index].id
}

resource "openstack_compute_floatingip_associate_v2" "fip_assoc_fixed" {
  count = var.public_floating_ip_fixed != "" ? 1 : 0
  floating_ip = var.public_floating_ip_fixed
  instance_id = openstack_compute_instance_v2.instance[count.index].id
}

locals {
  device_names = ["/dev/sdb","/dev/sdc","/dev/sdd","/dev/sde","/dev/sdf","/dev/sdg"]
}

locals {
  instance_volume_map =  merge([

    for idxi, instance in openstack_compute_instance_v2.instance.*:
    {
      for idxv in range(var.instance_volumes_count):
        "${instance.name}-volume-${idxv}" => {
            instance_name     = instance.name
            instance_id       = instance.id
            volume_name       = "${instance.name}-volume-${idxv}"
            device            = local.device_names[idxv]
          }
    }
    
  ]...)
}
