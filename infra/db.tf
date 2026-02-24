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

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.ssh_private_key_path)
    host        = twc_floating_ip.db-floating-ip.ip
  }

  provisioner "remote-exec" {
    inline = [
      # Установка MySQL (без запуска)
      "apt-get update -q",
      "DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server",
      "systemctl stop mysql",
      "systemctl disable mysql",

      # Блокировка внешних подключений на порт 3306 через iptables
      # Разрешаем только с localhost
      "iptables -A INPUT -p tcp --dport 3306 -s 127.0.0.1 -j ACCEPT",
      "iptables -A INPUT -p tcp --dport 3306 -j DROP",

      # Сохраняем правила iptables (для Ubuntu)
      "apt-get install -y iptables-persistent",
      "netfilter-persistent save",
    ]
  }
}
