terraform {
    required_providers {
        twc = {
            source = "tf.timeweb.cloud/timeweb-cloud/timeweb-cloud"
        }
    }
    required_version = ">= 0.13"
}

provider "twc" {
    token = "TIMEWEB_CLOUD_TOKEN"
}

resource "twc_floating_ip" "app-server-floating-ip" {
	availability_zone = "msk-1"
	ddos_guard = false
}

resource "twc_server" "app-server" {
	name = "app-server"
	preset_id = 4797
	project_id = 2197163
	os_id = 99
	availability_zone = "msk-1"
	is_root_password_required = true
	ssh_keys_ids = [551901]
	floating_ip_id = twc_floating_ip.app-server-floating-ip.id

	local_network {
	}
}
