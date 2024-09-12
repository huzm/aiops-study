# 配置TencentCloud Provider
provider "tencentcloud" {
  region = var.region
  secret_id = var.secret_id
  secret_key = var.secret_key
}

# 获取可用区
data "tencentcloud_availability_zones_by_product" "default" {
  product = "cvm"
}

# 获取可用镜像
data "tencentcloud_images" "default" {
  image_type = ["PUBLIC_IMAGE"]
  os_name = "ubuntu"
}

# 获取可用实例类型
data "tencentcloud_instance_types" "default" {
  # 机型族
  filter {
    name = "instance-family"
    values = ["SA5"]
  }
  cpu_core_count = 2
  memory_size = 4
  exclude_sold_out = true
}

# 创建CVM实例
resource "tencentcloud_instance" "web" {
  depends_on = [tencentcloud_security_group_lite_rule.default]
  count = 1
  instance_name = "web server"
  availability_zone = data.tencentcloud_availability_zones_by_product.default.zones.0.name
  image_id = data.tencentcloud_images.default.images.0.image_id
  instance_type = data.tencentcloud_instance_types.default.instance_types.0.instance_type
  system_disk_type = "CLOUD_BSSD"
  system_disk_size = 50
  allocate_public_ip = true
  internet_max_bandwidth_out = 100
  instance_charge_type = "SPOTPAID"
  orderly_security_groups = [tencentcloud_security_group.default.id]
  password = var.password
}

# 创建安全组
resource "tencentcloud_security_group" "default" {
  name = "tf-security-group"
  description = "tf security group"
}

# 创建安全组规则
resource "tencentcloud_security_group_lite_rule" "default" {
  security_group_id = tencentcloud_security_group.default.id
  ingress = [
    "ACCEPT#0.0.0.0/0#22#TCP",
    "ACCEPT#0.0.0.0/0#6443#TCP",
  ]
  egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL"
  ]
}