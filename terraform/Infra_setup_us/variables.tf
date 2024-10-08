variable "region" {
  type = map
  default = {
    "us"  = "us-east-1"
    "eu" = "eu-west-1"
  }
}




variable "ami_ubuntu_regions" {
  type = map
  default = {
    "us-east-1"  = "ami-0885b1f6bd170450c"
    "eu-west-1" = "ami-03cc8375791cb8bcf"
  }
}


variable "instance_type" {
  type = map
  default = {
    "small"  = "t2.micro"
    "medium"  = "t2.medium"
    "large"  = "t2.large"
  }
}




# variables.tf
variable "allowed_ports" {
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr_blocks = list(string)
    description = string
    # Add other optional attributes like "ipv6_cidr_blocks" or "security_group_id" if needed
  }))

  default = [
    {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH access"
    },
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP access from internal network"
    },
  ]
}


variable "db_user_name" {
  description= "db user name"
  type=string
}



variable "db_user_pass" {
  description= "db user pass"
  type=string
}






