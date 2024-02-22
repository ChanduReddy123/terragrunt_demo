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



#
# the state file for this folder will be maintained in the folder project1/sub-project1/terraform.tfstate
# path_relative_to_include in parent terragrunt.hcl will give project1/sub-project1/ in this context
#


#this dependency block will make sure to create the hard dependency on network and pull the required outputs of network and inject them to itself
# Module dependencies 
dependency "network" {
  config_path = "../../network"
}

# if there is no output in the landing_zone policy_name then this block will give us an error to run the landing_zone first
inputs = {
    vnet_id = dependency.network.outputs.vnet_id
}
