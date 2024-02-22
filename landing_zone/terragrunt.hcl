#this will ask this folder to fetch the parent terragrunt.hcl available in its parents folder and generate the required files
include {
  path = find_in_parent_folders()
}

# pass both parent common variables file and local variable file
terraform {
  extra_arguments "custom_vars" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=locals.tfvars",
      "-var-file=${get_parent_terragrunt_dir()}/global_vars.tfvars",
    ]
  }
}