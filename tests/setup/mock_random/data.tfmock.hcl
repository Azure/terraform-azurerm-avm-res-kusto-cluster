mock_resource "random_integer" {
  defaults = {
    result = 0
  }
}

mock_resource "random_string" {
  defaults = {
    result = "abcdefgh"
  }
}

mock_resource "random_uuid" {
  defaults = {
    result = "00000000-0000-0000-0000-000000000001"
  }
}
