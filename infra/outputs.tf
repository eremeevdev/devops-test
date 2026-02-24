output "app_server_ip" {
  description = "Плавающий IP сервера приложения"
  value       = twc_floating_ip.app-floating-ip.ip
}

output "db_server_ip" {
  description = "Плавающий IP сервера БД"
  value       = twc_floating_ip.db-floating-ip.ip
}

output "app_server_id" {
  value = twc_server.app-server.id
}

output "db_server_id" {
  value = twc_server.db-server.id
}
