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

resource "aws_iam_user" "my_iam_users" {
  #count = length(var.names)
  #name  = "my_iam_user_${count.index}"
  #name = var.names[count.index]
  for_each = var.names

  name = each.key
  tags = {
    country : each.value.country
    department : each.value.department
  }

}
