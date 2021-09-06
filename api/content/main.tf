resource "null_resource" "hello_world2" {
  provisioner "local-exec" {
    command = "env"
  }
}
