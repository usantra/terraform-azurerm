/*
variable "resource_tags" {
  description = "Provide resource tags"
  type        = map(string)
  default = {
    "env"   = "test"
    "owner" = "Upal"
  }
}
*/
variable "vnetname" {
  type    = string
  default = "TESTVNET"
}