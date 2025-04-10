output "external_ip" {
  value = google_compute_address.valheim_static_ip.address
}

output "vm_name" {
  value = google_compute_instance.valheim_vm.name
}
