# Local variables
locals {
    username = "admin"
    password = "!v3G@!4@Y"
    url = "https://sandboxapicdc.cisco.com"
    tenant = "THETECHGUY"
}

#EndPoint Group Map
variable "epg_map" {
    type = map (object( {
        bd = string
        app = string
    }
    ))
} 

#Bridge Domain Map
variable "bd_map" {
    type = map (object( {
        bd_subnet = string
        vrf = string
    }
    ))
}

#Application Profile Set
variable "app_set" {
    type = set (string)
}

#VRF Set
variable "vrf_set" {
    type = set (string)
}