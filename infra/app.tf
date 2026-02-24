resource "twc_floating_ip" "app-floating-ip" {
  availability_zone = "msk-1"
  ddos_guard        = false
}

resource "twc_server" "app-server" {
  name              = "app-server"
  preset_id         = 4797
  project_id        = 2197163
  os_id             = 99
  availability_zone = "msk-1"
  ssh_keys_ids      = [551901]
  floating_ip_id    = twc_floating_ip.app-floating-ip.id
}
