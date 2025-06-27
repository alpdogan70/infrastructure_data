#resource "openstack_compute_secgroup_v2" "ssh" {
#  name        = "ssh-from-all"
#  description = "ssh security group"
#  rule {
#    from_port   = 22
#    to_port     = 22
#    ip_protocol = "tcp"
#    cidr        = "0.0.0.0/0" #personal ip
#  }
#}

resource "openstack_networking_secgroup_v2" "ssh" {
  name        = "ssh-from-all"
  description = "ssh-from-all"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_ssh_rule_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ssh.id
}

resource "openstack_networking_secgroup_v2" "gitlab_ssh" {
  name        = "gitlab-ssh"
  description = "gitlab-ssh"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_gitlab_ssh_rule_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 2222
  port_range_max    = 2222
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.gitlab_ssh.id
}

resource "openstack_networking_secgroup_v2" "openvpn" {
  name        = "openvpn"
  description = "openvpn"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_openvpn_rule_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1194
  port_range_max    = 1194
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.openvpn.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_openvpn_rule_udp_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 1194
  port_range_max    = 1194
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.openvpn.id
}

#resource "openstack_compute_secgroup_v2" "ssh-internal" {
#  name        = "ssh-from-internal"
#  description = "ssh internal security group"
#  rule {
#    from_port   = 22
#    to_port     = 22
#    ip_protocol = "tcp"
#    cidr        = var.network_subnet_cidr
#  }
#}

resource "openstack_networking_secgroup_v2" "ssh-internal" {
  name        = "ssh-internal"
  description = "ssh-internal"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_ssh-internal_rule_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.ssh-internal.id
}

#resource "openstack_compute_secgroup_v2" "all_internal" {
#  name        = "all_internal"
#  description = "all_internal security group"
#  rule {
#    from_port   = 1
#    to_port     = 65535
#    ip_protocol = "tcp"
#    cidr        = "10.0.1.0/24"
#  }
#  rule {
#    from_port   = 1
#    to_port     = 65535
#    ip_protocol = "udp"
#    cidr        = "10.0.1.0/24"
#  }
#}

resource "openstack_networking_secgroup_v2" "all_internal" {
  name        = "all_internal"
  description = "all_internal"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_all_internal_rule_tcp_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.all_internal.id
  lifecycle {
    ignore_changes = [port_range_min, port_range_max]
  }
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_all_internal_rule_udp_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.all_internal.id
  lifecycle {
    ignore_changes = [port_range_min, port_range_max]
  }
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_all_internal_rule_pods_udp_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = var.network_subnet_pods_cidr
  security_group_id = openstack_networking_secgroup_v2.all_internal.id
  lifecycle {
    ignore_changes = [port_range_min, port_range_max]
  }
}

#resource "openstack_compute_secgroup_v2" "proxy" {
#  name        = "proxy"
#  description = "proxy security group"
#  rule {
#    from_port   = 80
#    to_port     = 80
#    ip_protocol = "tcp"
#    cidr        = "0.0.0.0/0"
#  }
#  rule {
#    from_port   = 443
#    to_port     = 443
#    ip_protocol = "tcp"
#    cidr        = "0.0.0.0/0"
#  }
#}

resource "openstack_networking_secgroup_v2" "proxy" {
  name        = "proxy"
  description = "proxy"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_all_internal_rule_http_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.proxy.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_all_internal_rule_https_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.proxy.id
}


resource "openstack_networking_secgroup_v2" "consul" {
  name        = "consul"
  description = "consul"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_consul_dns_tcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8600
  port_range_max    = 8600
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.consul.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_consul_dns_udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 8600
  port_range_max    = 8600
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.consul.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_consul_http_grpc" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8500
  port_range_max    = 8503
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.consul.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_consul_wlan_tcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8300
  port_range_max    = 8302
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.consul.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_consul_wlan_udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 8300
  port_range_max    = 8302
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.consul.id
}

resource "openstack_networking_secgroup_v2" "node_exporter" {
  name        = "node_exporter"
  description = "node_exporter"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_node_exporter" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9100
  port_range_max    = 9100
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.node_exporter.id
}

resource "openstack_networking_secgroup_v2" "k8s_internal_pods" {
  name        = "k8s_internal_pods"
  description = "k8s_internal_pods"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_k8s_internal_pods_rule_tcp_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "10.200.0.0/16"
  security_group_id = openstack_networking_secgroup_v2.k8s_internal_pods.id
  lifecycle {
    ignore_changes = [port_range_min, port_range_max]
  }
}

resource "openstack_networking_secgroup_v2" "k8s_internal_services" {
  name        = "k8s_internal_services"
  description = "k8s_internal_services"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_k8s_internal_services_rule_tcp_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "10.201.0.0/16"
  security_group_id = openstack_networking_secgroup_v2.k8s_internal_services.id
  lifecycle {
    ignore_changes = [port_range_min, port_range_max]
  }
}

resource "openstack_networking_secgroup_v2" "minio" {
  name        = "minio"
  description = "Security group for MinIO S3 service"
}

resource "openstack_networking_secgroup_rule_v2" "minio_api" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9000
  port_range_max    = 9000
  remote_ip_prefix  = "10.0.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.minio.id
}

resource "openstack_networking_secgroup_rule_v2" "minio_console" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9001
  port_range_max    = 9001
  remote_ip_prefix  = "10.0.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.minio.id
}

# Security group pour MQTT
resource "openstack_networking_secgroup_v2" "mqtt" {
  name        = "mqtt"
  description = "Security group for MQTT broker"
}

resource "openstack_networking_secgroup_rule_v2" "mqtt_broker" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1883
  port_range_max    = 1883
  remote_ip_prefix  = "10.0.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.mqtt.id
}

resource "openstack_networking_secgroup_rule_v2" "mqtt_websocket" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9001
  port_range_max    = 9001
  remote_ip_prefix  = "10.0.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.mqtt.id
}

# Security group pour InfluxDB
resource "openstack_networking_secgroup_v2" "influxdb" {
  name        = "influxdb"
  description = "Security group for InfluxDB"
}

resource "openstack_networking_secgroup_rule_v2" "influxdb_api" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8086
  port_range_max    = 8086
  remote_ip_prefix  = "10.0.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.influxdb.id
}

resource "openstack_networking_secgroup_v2" "web" {
  name        = "web"
  description = "Security group for web services (HTTP/HTTPS)"
}

resource "openstack_networking_secgroup_rule_v2" "web_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "10.0.1.0/24"  # Ajustez selon votre réseau interne
  security_group_id = openstack_networking_secgroup_v2.web.id
}

resource "openstack_networking_secgroup_rule_v2" "web_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "10.0.1.0/24"  # Ajustez selon votre réseau interne
  security_group_id = openstack_networking_secgroup_v2.web.id
}

resource "openstack_networking_secgroup_rule_v2" "web_ipmi" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 623
  port_range_max    = 623
  remote_ip_prefix  = "10.0.1.0/24"  # IPMI access
  security_group_id = openstack_networking_secgroup_v2.web.id
}