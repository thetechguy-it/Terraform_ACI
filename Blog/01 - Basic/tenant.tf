# Provider Declaration
terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
      version = "2.7.0"
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
  tenant_dn = aci_tenant.prod-tenant.id #It allows you to associate this VRF to the Tenant resource called "prod-tenant"
  name = "THETECHGUY_VRF"
  ip_data_plane_learning = "enabled"
  knw_mcast_act = "permit"
  pc_enf_dir = "ingress"
  pc_enf_pref = "enforced"
}

# Application Profile
resource "aci_application_profile" "prod-app" {
  tenant_dn = aci_tenant.prod-tenant.id #It allows you to associate this Application Profile to the Tenant resource called "prod-tenant"
  name = "THETECHGUY_APP"
}

# EPG1
resource "aci_application_epg" "prod-epg" {
    application_profile_dn = aci_application_profile.prod-app.id #It allows you to associate this EPG to the Application Profile resource called "prod-app"
    name = "THETECHGUY_EPG"
    relation_fv_rs_bd = aci_bridge_domain.prod-bd.id #It allows you to associate this EPG to the BD resource called "prod-bd"
}

# BD1
resource "aci_bridge_domain" "prod-bd" {
        tenant_dn = aci_tenant.prod-tenant.id #It allows you to associate this BD to the Tenant resource called "prod-tenant"
        name = "THETECHGUY_BD"
        arp_flood = "yes"
        unicast_route = "yes"
        relation_fv_rs_ctx = aci_vrf.prod-vrf.id #It allows you to associate this BD to the VRF resource called "prod-vrf"
}

# Subnet BD1
resource "aci_subnet" "foosubnet" {
        parent_dn = aci_bridge_domain.prod-bd.id #It allows you to associate this Subnet to the BD resource called "prod-bd"
        description = "subnet"
        ip = "192.168.188.254/24"
        preferred = "no"
        scope = ["public"]
        virtual = "no"
        ctrl = ["unspecified"]
}
