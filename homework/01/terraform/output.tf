output "public_ip" {
  description = "vm public ip address"
  value = tencentcloud_instance.web[0].public_ip
}

output "container_id" {
  description = "ID of the Docker container"
  value = docker_container.nginx.id
}

output "image_id" {
  description = "ID of the Docker image"
  value = docker_image.nginx.id
}

output "password" {
  description = "vm password"
  value = var.password
}