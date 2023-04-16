bd_map = {
    "PROD_BD" = {
        bd_subnet = "192.168.100.254/24"
        vrf = "PROD_VRF"
    }
    "DEMO_BD" = {
        bd_subnet = "192.168.200.254/24"
        vrf = "DEMO_VRF"
    }
}

epg_map = {
    "PROD_EPG1" = {
        bd = "PROD_BD"
        app = "PROD_APP"
    }
    "PROD_EPG2" = {
        bd = "PROD_BD"
        app = "PROD_APP"
    }
    "PROD_EPG3" = {
        bd = "PROD_BD"
        app = "PROD_APP"
    }
    "DEMO_EPG1" = {
        bd = "DEMO_BD"
        app = "DEMO_APP"
    }
}

app_set = [
    "PROD_APP",
    "DEMO_APP"
]

vrf_set = [
    "PROD_VRF",
    "DEMO_VRF"
]