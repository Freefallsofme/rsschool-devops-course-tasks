resource "aws_security_group" "nat_sg" {
  name        = "natsg"
  description = "Allow VPC traffic for NAT"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "NATSG"
  }
}

resource "aws_instance" "nat" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.nat_sg.id]
  source_dest_check           = false
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name

  user_data = <<-EOF
              #!/bin/bash
              if ! grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf; then
                echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
              else
                sed -i 's/^net.ipv4.ip_forward=.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf
              fi
              sysctl -w net.ipv4.ip_forward=1
              iptables -t nat -C POSTROUTING -o $(ip r | grep default | awk '{print $5}') -j MASQUERADE 2>/dev/null || \
              iptables -t nat -A POSTROUTING -o $(ip r | grep default | awk '{print $5}') -j MASQUERADE
              EOF

  tags = {
    Name = "NATInstance"
  }
}

