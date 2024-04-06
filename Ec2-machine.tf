resource "aws_instance" "myec2" {
   ami = "ami-0eba6c58b7918d3a1"
   instance_type = "t2.micro"
   key_name = "Tokyo"
   count = 3
   tags = {
    Name = "Instance ${count.index + 1}"
  }

# Install Ansible on the first instance only
  provisioner "remote-exec" {
      inline = [
      "if [ $(hostname) = 'Instance 1' ]; then sudo apt-get update  && sudo apt-get install -y software-properties-common && sudo apt-add-repository --yes --update ppa:ansible/ansible && sudo apt-get install -y ansible; fi"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu" # or your AMI's default user
      private_key =  file("./Tokyo.pem") # Path to your SSH private key
      host        = self.public_ip
    }

  }
}
