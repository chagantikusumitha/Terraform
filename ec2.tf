# EC2 (Deploy VMs)
resource "aws_instance" "public_instance" {
  ami                    = "ami-080e1f13689e07408" # Your AMI ID here
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = "devops" # Use the dynamically generated SSH key pair
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  user_data              = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "public_instance"
  }
}

resource "aws_instance" "private_instance" {
  ami                    = "ami-080e1f13689e07408" # Your AMI ID here
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  key_name               = "devops" # Use the dynamically generated SSH key pair
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  tags = {
    Name = "private_instance"
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF
}

# NGINX should be accessed from the internet
resource "aws_security_group" "nginx_sg" {
  vpc_id = aws_vpc.custom_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
