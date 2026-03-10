Step	                                   Action	                                                                 Command / Reference	Notes
1	Build custom image with Packer	        packer init .packer build server.pkr.hcl	                             Uses Azure credentials; outputs image_id
2	Initialize Terraform	                  terraform init	                                                       Prepares Terraform for provisioning
3	Plan & Apply Infrastructure	            terraform plan -out solution.planterraform apply solution.plan	       Deploys VNet, Subnet, NSG, Public IPs, Load Balancer, Availability Set,                                                                                                                    VMs with custom image
4	Verify Resources in Azure	              az vm list -g Azuredevops -o table 	                                   Screenshot for proof of deployment                                                                                  (and similar commands for NSG, LB, Public IPs, VNet)           
5	Customize / Cleanup	                    Edit terraform.tfvars or variables.tfterraform destroy -auto-approve	 Adjust VM count, sizes, image, location, and tags

