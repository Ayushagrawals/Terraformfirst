provider "aws" {
  region  = "us-east-1"
  version = "~>4.14.0"
}
resource "aws_s3_bucket" "my_s3_bucket_1" {
  bucket = "s3-practice-tera-bucket-1"

}

variable "names" {
  #default = ["ayush_user", "tom_user", "jane_user"]
  default = {
    ayush_user : { country : "India", department : "GwaliorDepartment" },
    tom_user : { country : "America", department : "NewJerseyDepartment" },
    jane_user : { country : "Hungary", department : "BudapestDepartment" }

  }
  #default="my_new_user"
}

/*resource "aws_iam_user" "my_iam_users" {
  #count = length(var.names)
  #name  = "my_iam_user_${count.index}"
  #name = var.names[count.index]
  /*for_each = var.names

  name = each.key
  tags = {
    country : each.value.country
    department : each.value.department
  }

}*/
variable "aws_key_pair" {
  default = "D:\\aws\\aws_keys\\ec2_firstpair.pem"
}
#for allowing every computer->SG
#HTTP SERVER ->80 tcp,22 tcp ssh,cidr ["0.0.0.0/0"]

resource "aws_security_group" "http-server-sg" {
  name   = "http-server-sg"
  vpc_id = "vpc-0380b41af7b0ecddb"
  #To allow traffic from
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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }


}
resource "aws_instance" "http_server" {
  ami                    = "ami-0022f774911c1d690"
  key_name               = "ec2_firstpair"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http-server-sg.id]
  subnet_id              = "subnet-0a2120a0c1d70c801"

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = var.aws_key_pair
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo service httpd start",
      "echo welcome to ayush ec2 ${self.public_dns} | sudo tee /var/www/html/index.html"
    ]

  }
}

