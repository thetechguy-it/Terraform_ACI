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




# ONLY FOR DEMONSTRATION
# EPG2
resource "aci_application_epg" "prod-epg2" {
    application_profile_dn = aci_application_profile.prod-app.id 
    name = "THETECHGUY_EPG2"
    relation_fv_rs_bd = aci_bridge_domain.prod-bd.id 
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

# EPG3
resource "aci_application_epg" "prod-epg3" {
    application_profile_dn = aci_application_profile.prod-app.id 
    name = "THETECHGUY_EPG3"
    relation_fv_rs_bd = aci_bridge_domain.prod-bd.id 
}