resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "private_key.pem"
  file_permission = 0700
}

resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "public_key.pub"
}

resource "aws_key_pair" "sigmoid12" {
  key_name   = "devops" # Name of the key pair
  public_key = local_file.public_key.content
}



