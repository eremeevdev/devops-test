resource "twc_floating_ip" "db-floating-ip" {
  availability_zone = "msk-1"
  ddos_guard        = false
}

resource "twc_server" "db-server" {
  name           = "db-server"
  preset_id      = 4797
  project_id     = 2197163
  os_id          = 99
  availability_zone = "msk-1"
  ssh_keys_ids   = [551901]
  floating_ip_id = twc_floating_ip.db-floating-ip.id
}

resource "local_file" "ansible_inventory" {
  depends_on = [
    twc_floating_ip.db-floating-ip,
    twc_floating_ip.app-floating-ip,
  ]
  content = templatefile("${path.module}/../ansible/inventory.tmpl", {
    db_ip  = twc_floating_ip.db-floating-ip.ip
    app_ip = twc_floating_ip.app-floating-ip.ip
  })
  filename = "${path.module}/../ansible/inventory.ini"
}
