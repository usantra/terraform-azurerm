terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.28.1"
    }
  }
}

provider "azuread" {
  tenant_id = "1b879fe1-7f9e-4d45-b85a-2d5b4fa9fdc7"
}

resource "azuread_invitation" "test" {

  for_each = var.user_details

  user_display_name  = each.key
  user_email_address = each.value
  redirect_url       = "https://portal.azure.com"
}

output "invitation_url" {
  value = zipmap([for test in azuread_invitation.test : test.user_display_name], [for test in azuread_invitation.test : test.redeem_url])
}

#This output block is required to add users to an Azure AD group
output "userids" {
  value = toset([for test in azuread_invitation.test : test.user_id])
}

/*
Source 1: https://stackoverflow.com/questions/64989080/terraform-modules-output-from-for-each
Source 2: https://developer.hashicorp.com/terraform/language/expressions/for
*/