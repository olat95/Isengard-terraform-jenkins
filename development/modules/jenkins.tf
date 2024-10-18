resource "aws_instance" "jenkins_instance" {
  ami                         = "ami-0f9b8b3adb65fae5e"
  instance_type               = "t3.micro"
  subnet_id                   = element(aws_subnet.public_subnet[*].id, 0)
  key_name                    = "jenkins_key"
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true
  # user_data = "${file("install_jenkins.sh")}"

  tags = {
    Name = "jenkins_instance"
  }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true
  }
}

resource "aws_security_group" "jenkins_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pel_jenkins_sg"
  }
}

output "ec2_public_ip" {
  value = aws_instance.jenkins_instance.public_ip
}