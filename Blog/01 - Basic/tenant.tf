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

# EPG to Domain
resource "aci_epg_to_domain" "prod-epg_to_domain" {
  application_epg_dn = aci_application_epg.prod-epg.id
  tdn = aci_physical_domain.Physical_Dom.id
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







# ONLY FOR DEMONSTRATION
# EPG2
resource "aci_application_epg" "prod-epg2" {
    application_profile_dn = aci_application_profile.prod-app.id 
    name = "THETECHGUY_EPG2"
    relation_fv_rs_bd = aci_bridge_domain.prod-bd2.id 
}

# BD2
resource "aci_bridge_domain" "prod-bd2" {
        tenant_dn = aci_tenant.prod-tenant.id 
        name = "THETECHGUY_BD2"
        arp_flood = "yes"
        unicast_route = "yes"
        relation_fv_rs_ctx = aci_vrf.prod-vrf.id 
}

# Subnet BD2
resource "aci_subnet" "prod-bd-subnet2" {
        parent_dn = aci_bridge_domain.prod-bd2.id 
        description = "subnet"
        ip = "192.168.255.254/24"
        preferred = "no"
        scope = ["public"]
        virtual = "no"
        ctrl = ["unspecified"]
}

# EPG2 to Domain
resource "aci_epg_to_domain" "prod-epg_to_domain2" {
  application_epg_dn = aci_application_epg.prod-epg2.id
  tdn = aci_physical_domain.Physical_Dom.id
}

# EPG3
resource "aci_application_epg" "prod-epg3" {
    application_profile_dn = aci_application_profile.prod-app.id 
    name = "THETECHGUY_EPG3"
    relation_fv_rs_bd = aci_bridge_domain.prod-bd.id 
}

# EPG3 to Domain
resource "aci_epg_to_domain" "prod-epg_to_domain3" {
  application_epg_dn = aci_application_epg.prod-epg3.id
  tdn = aci_physical_domain.Physical_Dom.id
}
