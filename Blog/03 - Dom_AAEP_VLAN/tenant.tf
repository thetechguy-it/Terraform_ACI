# Provider Declaration
terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
    }
  }
}

# Provider Configuration
provider "aci" {
  username = local.username
  password = local.password
  url = local.url
}

# Tenant
resource "aci_tenant" "prod-tenant" {
  name = "THETECHGUY"
  description = "Production Tenant"
}

# VRF
resource "aci_vrf" "prod-vrf" {
  tenant_dn = aci_tenant.prod-tenant.id 
  name = "THETECHGUY_VRF"
  ip_data_plane_learning = "enabled"
  knw_mcast_act = "permit"
  pc_enf_dir = "ingress"
  pc_enf_pref = "enforced"
}

# Application Profile
resource "aci_application_profile" "prod-app" {
  tenant_dn = aci_tenant.prod-tenant.id 
  name = "THETECHGUY_APP"
}

# EPG1
resource "aci_application_epg" "prod-epg" {
    application_profile_dn = aci_application_profile.prod-app.id 
    name = "THETECHGUY_EPG"
    relation_fv_rs_bd = aci_bridge_domain.prod-bd.id 
}

# BD1
resource "aci_bridge_domain" "prod-bd" {
        tenant_dn = aci_tenant.prod-tenant.id 
        name = "THETECHGUY_BD"
        arp_flood = "yes"
        unicast_route = "yes"
        relation_fv_rs_ctx = aci_vrf.prod-vrf.id 
}

# Subnet BD1
resource "aci_subnet" "prod-bd-subnet" {
        parent_dn = aci_bridge_domain.prod-bd.id 
        description = "subnet"
        ip = "192.168.188.254/24"
        preferred = "no"
        scope = ["public"]
        virtual = "no"
        ctrl = ["unspecified"]
}

# VLAN Pool
resource "aci_vlan_pool" "Physical_VLAN-Pool" {
  name = "Physical_VLAN-Pool"
  alloc_mode = "static"
}
resource "aci_ranges" "prod-vlanpool-range" {
  vlan_pool_dn = aci_vlan_pool.Physical_VLAN-Pool.id
  from = "vlan-2"
  to = "vlan-1000"
  alloc_mode = "static"
}

# Physical Domain
resource "aci_physical_domain" "Physical_Dom" {
  name = "Physical_Dom"
  relation_infra_rs_vlan_ns = aci_vlan_pool.Physical_VLAN-Pool.id
}

# AAEP
resource "aci_attachable_access_entity_profile" "Physical_AAEP" {
  name = "Physical_AAEP"
}

# AAEP and Domain Association
resource "aci_aaep_to_domain" "aaep_to_domain" {
  attachable_access_entity_profile_dn = aci_attachable_access_entity_profile.Physical_AAEP.id
  domain_dn = aci_physical_domain.Physical_Dom.id
}