terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.84"  # Версия может отличаться
    }
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}

# Переменная для сети и подсети
variable "network_id" {
  description = "ID существующей сети"
  type        = string
  default     = "enphdqp2qandqml0d4oc"  # Укажите ID сети 'default' здесь
}

variable "subnet_id" {
  description = "ID существующей подсети в зоне ru-central1-a"
  type        = string
  default     = "e9bsp7kab2ro03vo896e"  # Укажите ID подсети 'default-ru-central1-a' здесь
}

# Виртуальная машина в зоне ru-central1-a
resource "yandex_compute_instance" "master_server" {
  name     = "master"
  hostname = "master"
  zone     = "ru-central1-a"

  resources {
    cores         = 2               # 2 ядра
    core_fraction = 20              # Прерываемая ВМ с 20% CPU
    memory        = 2               # 2 Гб памяти
  }

  boot_disk {
    initialize_params {
      image_id = "fd8p4jt9v2pfq4ol9jqh"  # Ubuntu 22.04
      size     = 10  # Диск 10 Гб (HDD)
      type     = "network-hdd"
    }
  }

  scheduling_policy {
    preemptible = true  # Прерываемая ВМ
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "user:${file("/home/user/.ssh/id_ed25519.pub")}"
  }
}