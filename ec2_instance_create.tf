resource "aws_instance" "instance1" {
  ami             = "ami-00c03f7f7f2ec15c3"
  instance_type   = "t2.micro"
  key_name = "terrafgit"
  security_groups = ["default"]

  tags {
    Name = "instance1"
  }
}
resource "aws_instance" "instance2" {
  ami             = "ami-00c03f7f7f2ec15c3"
  instance_type   = "t2.micro"
  key_name = "terrafgit"
  security_groups = ["default"]

  tags {
    Name = "instance2"
  }
}
resource "aws_elb" "testing1" {
  name               = "testing-elb"
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]
listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
instances                   = ["${aws_instance.instance1.id}", "${aws_instance.instance2.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "testing-elb"
  }
}

