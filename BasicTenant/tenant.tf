# Provider Declaration
terraform {
  required_providers {
    aci = {
      source = "ciscodevnet/aci"
      version = "2.7.0"
    }
  }
}

# Provider Configuration
provider "aci" {
  username = "admin"
  password = "!v3G@!4@Y"
  url = "https://sandboxapicdc.cisco.com"
}

# Tenant
resource "aci_tenant" "test-tenant" {
  name = "THETECHGUY"
}

# VRF
resource "aci_vrf" "test-vrf" {
  tenant_dn = aci_tenant.test-tenant.id
  name = "THETECHGUY_VRF"
  ip_data_plane_learning = "enabled"
  knw_mcast_act = "permit"
  pc_enf_dir = "ingress"
  pc_enf_pref = "enforced"
}

# Application Profile
resource "aci_application_profile" "test-app" {
  tenant_dn = aci_tenant.test-tenant.id
  name = "THETECHGUY_APP"
}

# EPG1
resource "aci_application_epg" "test-epg" {
    application_profile_dn = aci_application_profile.test-app.id
    name = "THETECHGUY_EPG"
    pc_enf_pref = "unenforced"
    pref_gr_memb = "include"
    prio = "unspecified"
    relation_fv_rs_bd = aci_bridge_domain.test-bd.id
}

# BD1
resource "aci_bridge_domain" "test-bd" {
        tenant_dn = aci_tenant.test-tenant.id
        name = "THETECHGUY_BD"
        arp_flood = "yes"
        unicast_route = "yes"
        relation_fv_rs_ctx = aci_vrf.test-vrf.id
}

# Subnet BD1
resource "aci_subnet" "foosubnet" {
        parent_dn = aci_bridge_domain.test-bd.id
        description = "subnet"
        ip = "192.168.188.254/24"
        preferred = "no"
        scope = ["public"]
        virtual = "no"
        ctrl = ["unspecified"]
}
