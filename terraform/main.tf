provider "heroku" {
  email   = var.heroku_email
  api_key = var.heroku_api_key
}

provider "aws" {
  version = "~> 3.0"
  region  = "us-west-2"
}


resource "aws_iam_user" "lb" {
  name = "discord-bot"
  path = "/dnd-apps/"

  tags = {
    Project = var.project_name
  }
}

resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.lb.name
}

data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}


resource "aws_iam_user_policy" "lb_ro" {
  name = "test"
  user = aws_iam_user.lb.name

  policy = data.aws_iam_policy_document.example
}


resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "dnd-discord-bot"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "unique_id"
  range_key      = "name"

  attribute {
    name = "unique_id"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }

  tags = {
    Name        = "dnd-discord-bot"
    Environment = "production"
    Project = var.project_name
  }
}

resource "heroku_deployment" "default" {
  name   = "my-cool-app"
  region = "us"

  config_vars = {
    FOOBAR = "baz"
  }

  buildpacks = [
    "heroku/ruby"
  ]
}
