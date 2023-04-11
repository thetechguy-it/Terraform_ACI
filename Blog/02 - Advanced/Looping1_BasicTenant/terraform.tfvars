#epgs_set = [
#    "EPG1",
#    "EPG2",
#    "EPG3"
#]

#bds_set = [
#    "BD1",
#    "BD2",
#    "BD3"
#]

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
    }
    "EPG2" = {
        bd = "BD2"
    }
    "EPG3" = {
        bd = "BD3"
    }
}