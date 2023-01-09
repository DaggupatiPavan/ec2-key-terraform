provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "demo2" {
  key_name   = var.key_name
  public_key = file("${var.pub_key_path}")
}

resource "aws_instance" "dev" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    "Name" = "dev-1"
  }
  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/*",
      "bash /tmp/web.sh"
    ]
  }

  connection {
    user        = var.user_name
    private_key = file("${var.pri_key_path}")
    host        = self.public_ip
  }

}
