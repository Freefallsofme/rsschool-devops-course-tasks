resource "aws_instance" "k3s_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = aws_key_pair.deployer.key_name

  user_data = <<-EOF
#!/bin/bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644" sh -
EOF

  tags = {
    Name = "k3s-server"
  }
}

resource "null_resource" "wait_for_token" {
  depends_on = [aws_instance.k3s_server]

  provisioner "remote-exec" {
    connection {
      type  = "ssh"
      user  = "ubuntu"
      host  = aws_instance.k3s_server.private_ip
      agent = true
    }

    inline = [
      "until [ -f /var/lib/rancher/k3s/server/node-token ]; do sleep 5; done"
    ]
  }
}

data "external" "k3s_token" {
  depends_on = [null_resource.wait_for_token]

  program = [
    "bash", "-c",
    "ssh -o StrictHostKeyChecking=no -J ubuntu@${aws_instance.bastion.public_ip} ubuntu@${aws_instance.k3s_server.private_ip} 'sudo cat /var/lib/rancher/k3s/server/node-token'"
  ]
}

resource "aws_instance" "k3s_agent" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private[1].id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = aws_key_pair.deployer.key_name

  user_data = <<-EOF
#!/bin/bash
curl -sfL https://get.k3s.io | K3S_URL=https://${aws_instance.k3s_server.private_ip}:6443 K3S_TOKEN=${data.external.k3s_token.result} sh -
EOF

  depends_on = [data.external.k3s_token]

  tags = {
    Name = "k3s-agent"
  }
}

