terraform {
  backend "remote" {
    organization = "mkaesz-dev"

    workspaces {
      name = "helloworld"
    }
  }
}


resource "null_resource" "hello_world" {
  provisioner "local-exec" {
    command = "env"
  }
}

resource "null_resource" "hello_world3" {
  provisioner "local-exec" {
    command = "env"
  }
}
