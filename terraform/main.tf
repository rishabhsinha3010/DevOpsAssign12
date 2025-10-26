provider "aws" {
  region = "us-east-1"  # Free tier available
}

resource "aws_key_pair" "deployer" {
  key_name   = "devops-key"
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_security_group" "devops_sg" {
  name        = "devops-sg"
  description = "Allow SSH, HTTP, and custom ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (restrict later if needed)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS
  }

  ingress {
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Docker Swarm manager
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Swarm gossip
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]  # Overlay network
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound
  }
}

resource "aws_instance" "controller" {
  ami           = "ami-0fb0b230890ccd1e6"  # Ubuntu 20.04 LTS (latest)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.devops_sg.name]
  
  # Add delay to avoid throttling
  depends_on = [aws_key_pair.deployer]
  
  tags = {
    Name = "Controller"
  }
}

resource "aws_instance" "swarm_manager" {
  ami           = "ami-0fb0b230890ccd1e6"  # Ubuntu 20.04 LTS (latest)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.devops_sg.name]
  
  # Add delay to avoid throttling
  depends_on = [aws_instance.controller]
  
  tags = {
    Name = "SwarmManager"
  }
}

# Comment out workers for now - create them later
# resource "aws_instance" "swarm_worker_a" {
#   ami           = "ami-0fb0b230890ccd1e6"  # Ubuntu 20.04 LTS (latest)
#   instance_type = "t2.micro"
#   key_name      = aws_key_pair.deployer.key_name
#   security_groups = [aws_security_group.devops_sg.name]
#   
#   # Add delay to avoid throttling
#   depends_on = [aws_instance.swarm_manager]
#   
#   tags = {
#     Name = "SwarmWorkerA"
#   }
# }

# resource "aws_instance" "swarm_worker_b" {
#   ami           = "ami-0fb0b230890ccd1e6"  # Ubuntu 20.04 LTS (latest)
#   instance_type = "t2.micro"
#   key_name      = aws_key_pair.deployer.key_name
#   security_groups = [aws_security_group.devops_sg.name]
#   
#   # Add delay to avoid throttling
#   depends_on = [aws_instance.swarm_worker_a]
#   
#   tags = {
#     Name = "SwarmWorkerB"
#   }
# }

resource "aws_eip" "controller_eip" {
  instance = aws_instance.controller.id
}

resource "aws_eip" "swarm_manager_eip" {
  instance = aws_instance.swarm_manager.id
}

# Comment out worker EIPs for now
# resource "aws_eip" "swarm_worker_a_eip" {
#   instance = aws_instance.swarm_worker_a.id
# }

# resource "aws_eip" "swarm_worker_b_eip" {
#   instance = aws_instance.swarm_worker_b.id
# }

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.example.private_key_pem
  filename = "terraform-key.pem"
  file_permission = "0600"
}

output "controller_ip" {
  value = aws_eip.controller_eip.public_ip
}

output "swarm_manager_ip" {
  value = aws_eip.swarm_manager_eip.public_ip
# Comment out worker outputs for now
# output "swarm_worker_a_ip" {
#   value = aws_eip.swarm_worker_a_eip.public_ip
# }

# output "swarm_worker_b_ip" {
#   value = aws_eip.swarm_worker_b_eip.public_ip
# }