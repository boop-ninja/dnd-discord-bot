variable "project_name" {
  type = string
  default = "dnd_apps_discord_bot"
}

variable "environemnt" {
  type = string
  default = "production"
}

variable "heroku_email" {
  type = string
}

variable "heroku_api_key" {
  type = string
}

variable "google_analytics_site_id" {
  type = string
}

variable "discord_bot_token" {
  type = string
}

variable "aws_dynamodb_table" {
  type = string
  default = "dnd_discord_bot"
}

variable "aws_dynamodb_hash_key" {
  type = string
  default = "id"
}

variable "aws_dynamodb_range_key" {
  type = string
  default = "tags"
}
