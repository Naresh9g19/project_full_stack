provider "aws" {
  region = var.region["eu"]
  profile                 = "default"
}




resource "aws_instance" "tfvm2" {
  
  availability_zone= "eu-west-2a"
  ami = var.ami_ubuntu_regions[var.region["eu"]]
  instance_type = var.instance_type["small"]
  
  vpc_security_group_ids = [ aws_security_group.web-server_eu.id ]

  user_data=file("user_data_sh.sh")
    tags = {
      Name = "WEB-demo"
    }
}




output "instance_ips2" {
  value = aws_instance.tfvm2.public_ip
}




resource "aws_security_group" "alb_sg2" {
  name = "alb-security-group"
  ingress {
    from_port = 80
    to_port   = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




##

  

##


resource "aws_security_group" "web-server_eu" {
  name = "web-server_eu"
  

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port= ingress.value.from_port
      to_port= ingress.value.to_port
      protocol= ingress.value.protocol
      cidr_blocks= ingress.value.cidr_blocks

      # Add other attributes based on the variable definition
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Add similar dynamic block for "egress" rules if needed
}







resource "aws_lb_target_group" "target-group2" {
  name        = "nit-tg2"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "vpc-03029a3f4a675c7fc"

  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# creating ALB
resource "aws_lb" "application-lb2" {
  name               = "nit-alb2"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-0158c4c01a2e0950a","subnet-0680ab3a54a5d97d2"]
  security_groups    = [aws_security_group.web-server_eu.id]
  ip_address_type    = "ipv4"

  tags = {
    name = "nit-alb2"
    
  }
}

resource "aws_lb_listener" "alb-listener2" {
  load_balancer_arn = aws_lb.application-lb2.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group2.arn
  }
}

resource "aws_lb_target_group_attachment" "ec2_attach2" {
  target_group_arn = aws_lb_target_group.target-group2.arn
  target_id        = aws_instance.tfvm2.id
}



resource "aws_security_group" "dbsg" {
  
  name        = "dbsg"
  description = "Allow all inbound for Postgres"
ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_instance" "database_instance" {
  identifier             = "database-instance"
  engine_version       = "14.10"
  db_name              = "sampleDB"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  #PostgreSQL 14.12-R2
  #engine_version         = "14.12"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.dbsg.id]
  username               = var.db_user_name
  password               = var.db_user_pass

  
}






