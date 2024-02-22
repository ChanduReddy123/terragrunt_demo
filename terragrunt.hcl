## remote backend generater
# this will generate the backend.tf file in the child folders with same local relative path and update in key
# this config is used to maintain the state in remote storage account
remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    resource_group_name  = "resource_group"
    storage_account_name = "storage_account"
    container_name       = "container_name"
    subscription_id      = "subscription_id_where_storage_account_is_available"
    snapshot             = true
  }
}

# Inject the common variables to child with this
## terraform global vars
terraform {
  extra_arguments "custom_vars" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=global_vars.tfvars"
    ]
  }
}
# Generate the variables file in the child folder

generate "variables" {
  path      = "root_variables.tf"
  if_exists = "overwrite"
  contents  = file("global_variables.tf")
}

# Generate the common provider for the child folders
# ## terraform provider generate
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
}
 EOF
}

# Generate the terraform version block in the child folders
## terraform version generate
generate "version" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
  required_version = "1.2.5"
}
EOF
}

