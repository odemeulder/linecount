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
    allowed_methods = ["GET"]
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
      "Resource": "arn:aws:s3:::odm-linecount"
    }
  ]
}
EOF
}

resource "aws_instance" "linecount" {
  ami           = "ami-017b013ef58a362fb"
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.linecount_profile.name}"

  tags = {
    Application = "linecount"
    Environment = "prd"
  }
}

