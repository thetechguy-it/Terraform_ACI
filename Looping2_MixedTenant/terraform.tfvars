bd_map = {
    "BD1" = {
        bd_subnet = "192.168.1.1/24"
    }
    "BD2" = {
        bd_subnet = "192.168.2.1/24"
    }
    "BD3" = {
        bd_subnet = "192.168.3.1/24"
    }
}

epg_map = {
    "EPG1" = {
        bd = "BD1"
        app = "THETECHGUY_APP1"
    }
    "EPG2" = {
        bd = "BD2"
        app = "THETECHGUY_APP1"
    }
    "EPG3" = {
        bd = "BD3"
        app = "THETECHGUY_APP2"
    }
}

app_set = [
    "THETECHGUY_APP1",
    "THETECHGUY_APP2"
]