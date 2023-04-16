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
resource "aci_tenant" "prod-tenant" {
  name = local.tenant
  description = "Production Tenant"
}

# VRF
resource "aci_vrf" "prod-vrf" {
  tenant_dn  = aci_tenant.prod-tenant.id
  name = local.vrf
  ip_data_plane_learning = "enabled"
  knw_mcast_act = "permit"
  pc_enf_dir = "ingress"
  pc_enf_pref = "enforced"
}

# Application Profile
resource "aci_application_profile" "prod-app" {
  for_each = var.app_set
  name = each.value
  tenant_dn = aci_tenant.prod-tenant.id
  #name = local.app_profile
}

# EPGx LOOP EXTERNAL VARIABLES
resource "aci_application_epg" "prod-epg" {
  for_each = var.epg_map
  name = each.key
  relation_fv_rs_bd = aci_bridge_domain.prod-bd[each.value.bd].id
  application_profile_dn = aci_application_profile.prod-app[each.value.app].id
  pc_enf_pref = "unenforced"
  pref_gr_memb = "include"
  prio = "unspecified"
}

# BDx LOOP EXTERNAL VARIABLES
resource "aci_bridge_domain" "prod-bd" {
  for_each = var.bd_map
  name = each.key
  arp_flood = "yes"
  unicast_route = "yes"
  unk_mac_ucast_act = "flood"
  relation_fv_rs_ctx = aci_vrf.prod-vrf.id
  tenant_dn  = aci_tenant.prod-tenant.id
}

# Subnet
resource "aci_subnet" "prod-bdsubnet" {
  for_each = var.bd_map
  ip = each.value.bd_subnet
  parent_dn = aci_bridge_domain.prod-bd[each.key].id
  scope = [ "public" ]
  ctrl = ["unspecified"]
}

# Physical Domain
resource "aci_physical_domain" "prod-domain" {
  name  = local.phy_domain
}

# EPG to Domain
resource "aci_epg_to_domain" "prod-epg_to_domain" {
  for_each = var.epg_map
  application_epg_dn = aci_application_epg.prod-epg[each.key].id
  tdn = aci_physical_domain.prod-domain.id
}