# Azure-Blob
Terraform script to create azure blob and enable time based retention on blob container


Uses **AzApi** to enable time-based retention on Azure storage container.

AzApi is used since there is gap in AzureRM provider since it alone cannot set this policy. Hence, AzApi provider was used in terraform to bridge that gap.

# Test
To test it, you can use Azure CLI to create these files and execute them using basic terraform command.

*terraform init*

*terraform plan*

*terraform apply*
