# Provider Declaration
terraform {
  required_providers {
    aci = {
      source = "ciscodevnet/aci"
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
resource "aci_tenant" "test-tenant" {
  name = local.tenant
}

# VRF
resource "aci_vrf" "test-vrf" {
  tenant_dn  = aci_tenant.test-tenant.id
  name = local.vrf
  ip_data_plane_learning = "enabled"
  knw_mcast_act = "permit"
  pc_enf_dir = "ingress"
  pc_enf_pref = "enforced"
}

# Application Profile
resource "aci_application_profile" "test-app" {
  tenant_dn = aci_tenant.test-tenant.id
  name = local.app_profile
}

# EPGx LOOP EXTERNAL VARIABLES
resource "aci_application_epg" "test-epg" {
    for_each = var.epg_map
    name = each.key
    application_profile_dn = aci_application_profile.test-app.id
    relation_fv_rs_bd = aci_bridge_domain.test-bd[each.value.bd].id
    pc_enf_pref = "unenforced"
    pref_gr_memb = "include"
    prio = "unspecified"
}

# BDx LOOP EXTERNAL VARIABLES
resource "aci_bridge_domain" "test-bd" {
        for_each = var.bd_map
        name = each.key
        arp_flood = "yes"
        unicast_route = "yes"
        unk_mac_ucast_act = "flood"
        relation_fv_rs_ctx = aci_vrf.test-vrf.id
        tenant_dn  = aci_tenant.test-tenant.id
}

# Subnet
resource "aci_subnet" "test-bdsubnet" {
    for_each = var.bd_map
    ip = each.value.bd_subnet
    parent_dn = aci_bridge_domain.test-bd[each.key].id
    scope = [ "public" ]
    ctrl = ["unspecified"]
}

# Physical Domain
resource "aci_physical_domain" "test-domain" {
  name  = local.phy_domain
}

# EPG to Domain
resource "aci_epg_to_domain" "test-epg_to_domain" {
  for_each = var.epg_map
  application_epg_dn = aci_application_epg.test-epg[each.key].id
  tdn = aci_physical_domain.test-domain.id
}