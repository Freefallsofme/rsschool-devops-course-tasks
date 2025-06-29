resource "aws_instance" "k3s_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = aws_key_pair.deployer.key_name

  user_data = <<-EOF
#!/bin/bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644 --token ${var.k3s_token}" sh -
EOF

  tags = {
    Name = "k3s-server"
  }
}

resource "aws_instance" "k3s_agent" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private[1].id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = aws_key_pair.deployer.key_name

  user_data = <<-EOF
#!/bin/bash
curl -sfL https://get.k3s.io | K3S_URL="https://${aws_instance.k3s_server.private_ip}:6443" K3S_TOKEN="${var.k3s_token}" sh -
EOF

  depends_on = [aws_instance.k3s_server]

  tags = {
    Name = "k3s-agent"
  }
}

