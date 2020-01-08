resource "openstack_networking_network_v2" "nodes_net" {
  name           = "${var.cluster_name}-nodes-net"
  admin_state_up = "true"
  port_security_enabled = "true"
}

resource "openstack_networking_subnet_v2" "nodes_subnet" {
  name       = "${var.cluster_name}-nodes-subnet"
  network_id = openstack_networking_network_v2.nodes_net.id
  cidr       = var.nodes_net_cidr
  ip_version = 4
}

data "openstack_networking_network_v2" "public_net" {
  name = var.public_net_name
}

resource "openstack_networking_router_v2" "router" {
  name                = "${var.cluster_name}-router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.public_net.id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.nodes_subnet.id
}
