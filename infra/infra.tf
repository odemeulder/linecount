provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_s3_bucket" "linecount_bucket" {
  bucket = "odm-linecount"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  tags = {
    Application = "linecount"
    Environment = "prd"
  }
}

resource "aws_iam_role" "linecount_role" {

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Application = "linecount"
  }
}

resource "aws_iam_instance_profile" "linecount_profile" {
  role = "${aws_iam_role.linecount_role.name}"
}

resource "aws_iam_role_policy" "linecount_policy" {
  role = "${aws_iam_role.linecount_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::odm-linecount/*"
    }
  ]
}
EOF
}

resource "aws_key_pair" "linecount_key_pair" {
  key_name   = "linecount-ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDn/m6VZhis/1E5B71XLQO6KCCN2EuXaSNPe549henyYQbmMk1GG2KvV4bXepdXwULBJesd1QLaUqq176D0GftDv7SSUKV0kZTpYhdnDXCrIeXhBuSJtce9QovmX+1slGMnUEIqePgOTPFYVJ0iD4ojXNGVOo3VZDFo1JhvpVw0jETLIOKYFqcEUmgJSRJU1H8jFEpNmOIOuvuxTWjgZC98rUbAF+OqjOmNJbiFQ+wYQHz7PhXPjFjYipXfsodXYN/gdO6c2KQIsXuIX2x885s4UIqO5WmefPxZnrebHXLffRIWiEFp9hnNFteVNNkfDmuwJZBQXRgI6mb2f7Z1Dn59"
}

resource "aws_security_group" "linecount_sg" {
  vpc_id = "vpc-edf80c94"

  ingress {
    description = "TLS from everywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Application = "linecount"
  }
}

resource "aws_instance" "linecount" {
  ami           = "ami-017b013ef58a362fb"
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.linecount_profile.name}"
  key_name = "linecount-ssh-key"
  vpc_security_group_ids = [ "${aws_security_group.linecount_sg.id}" ]

  tags = {
    Application = "linecount"
    Environment = "prd"
  }
}

output "instance_ips" {
  value = ["${aws_instance.linecount.*.public_ip}"]
}

