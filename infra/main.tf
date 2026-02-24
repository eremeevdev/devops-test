terraform {
  required_providers {
    twc = {
      source  = "tf.timeweb.cloud/timeweb-cloud/timeweb-cloud"
      version = "~> 1.0"
    }
  }
  required_version = ">= 0.13"
}

provider "twc" {
  token = var.token
}
