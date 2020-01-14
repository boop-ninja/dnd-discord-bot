provider "aws" {
  region  = "us-west-2"
}

provider "heroku" {
  email   = var.heroku_email
  api_key = var.heroku_api_key
}

data "aws_iam_policy_document" "example" {
  statement {
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem"
    ]
    resources = [
      aws_dynamodb_table.prod_dynamodb_table.arn
    ]
  }
}

resource "aws_iam_user" "lb" {
  name = "discord_bot"
  path = "/dnd_apps/"

  tags = {
    name        = "dnd_discord_bot"
    environment = var.environemnt
    project     = var.project_name
  }
}

resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.lb.name
}


resource "aws_iam_user_policy" "lb_ro" {
  name = var.project_name
  user = aws_iam_user.lb.name
  policy = data.aws_iam_policy_document.example.json
}


resource "aws_dynamodb_table" "prod_dynamodb_table" {
  name           = "${var.aws_dynamodb_table}_${var.environemnt}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.aws_dynamodb_hash_key
  range_key      = var.aws_dynamodb_range_key

  attribute {
    name = var.aws_dynamodb_hash_key
    type = var.aws_dynamodb_range_key
  }

  attribute {
    name = "tags"
    type = "S"
  }

  tags = {
    name        = "dnd_discord_bot"
    environment = var.environemnt
    project     = var.project_name
  }
}

resource "heroku_app" "dnd_discord_bot" {
  name   = var.project_name
  region = "us"

  config_vars = {
    RACK_ENV = var.environemnt
    AWS_REGION = "us-west-2"
  }

  sensitive_config_vars = {
    AWS_ACCESS_KEY_ID = aws_iam_access_key.lb.id
    AWS_SECRET_ACCESS_KEY = aws_iam_access_key.lb.secret
    GOOGLE_ANALYTICS_SITE_ID = var.google_analytics_site_id
    DISCORD_BOT_TOKEN = var.discord_bot_token
  }

  buildpacks = [
    "heroku/ruby"
  ]
}
