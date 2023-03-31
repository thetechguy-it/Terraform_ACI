#variable "epgs_set" {
#    type = set (string)
#}

#variable "bds_set" {
#    type = set (string)
#}

variable "epg_map" {
    type = map (object( {
        bd = string
    }
    ))
} 

variable "bd_map" {
    type = map (object( {
        bd_subnet = string
    }
    ))
}


locals {
    username = "admin"
    password = "!v3G@!4@Y"
    url = "https://sandboxapicdc.cisco.com"
}