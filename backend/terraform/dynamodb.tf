resource "aws_dynamodb_table" "wonderkid_potential" {
  name           = "WonderkidPotansiyeldb"
  hash_key       = "PlayerID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "PlayerID"
    type = "S"
  }

  tags = {
    Name = "WonderkidPotansiyeldb"
  }
}
