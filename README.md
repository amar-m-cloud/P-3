# P-3

Prerequisites:
- Install Terraform: https://learn.hashicorp.com/tutorials/terraform/install-cli
- AWS CLI installed and configured: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html

Step 1: Create a Terraform Configuration File (e.g., main.tf)

Step 2: Create Module Directories and Files
- Create directories named modules and add the following module files inside it:

Step 3: Initialize and Apply Terraform
- Open a terminal and navigate to the directory containing your main.tf file.
- Run the following commands:
  - terraform init
  - terraform apply
- Confirm the deployment by typing yes when prompted.

Step 4: Access the WordPress Site
- Once the Terraform script execution is complete, you can access your WordPress site using the Load Balancer DNS name provided in the output:
  - terraform output load_balancer_dns

Step 5: Configure Route 53 (Optional)
- If you configured Route 53, update your domain's nameservers with the values provided in the Terraform output:
  - terraform output name_servers

Step 6: Destroy Resources (Optional)
- If you want to tear down the infrastructure created by Terraform, run:
  - terraform destroy
- Confirm by typing yes when prompted.
