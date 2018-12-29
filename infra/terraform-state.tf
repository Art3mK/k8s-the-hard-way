# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "artemk-tfstate"
#   versioning {
#     enabled = true
#   }
#   lifecycle {
#     prevent_destroy = true
#   }
# }

