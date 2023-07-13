# Launch PrestaShop on AWS EC2

This script automates the deployment of PrestaShop, an open-source e-commerce platform, on Amazon Web Services (AWS) EC2 instances.

## Prerequisites

Before running the script, make sure you have the following prerequisites:

- An AWS account with appropriate permissions
- AWS CLI installed and configured
- SSH key pair created on AWS
- Subnet ID, Security Group IDs, and Key Pair name configured in the script
- Startup scripts (`app_startup_script.sh` and `db_startup_script.sh`) for application and database servers

## Configuration

Before running the script, modify the following variables in the script:

- `REGION`: AWS region to launch the instances in
- `APP_INSTANCE_TYPE`: EC2 instance type for the application server
- `DB_INSTANCE_TYPE`: EC2 instance type for the database server
- `SUBNET_ID`: ID of the subnet to launch the instances in
- `APP_SG_ID`: ID of the security group for the application server
- `DB_SG_ID`: ID of the security group for the database server
- `KEY_NAME`: Name of the SSH key pair
- `APP_USER_DATA`: Path to the application server startup script
- `DB_USER_DATA`: Path to the database server startup script
- `PRESTASHOP_VERSION`: Version of PrestaShop to install

## Usage

1. Make the shell script file executable by running the following command:

   ```bash
   chmod +x launch_prestashop.sh

2. Run the shell script by executing the following command:

 ```bash
 ./launch_prestashop.sh

The script will launch the application server and database server instances, wait for them to be running, install PrestaShop on both servers, and update the configuration file with the database server details. Once the installation is complete, it will display the URLs to access the application and the database server.

Please note that you need to replace the placeholders (xxxxxxxxxxxxxxx) in the script with the actual values specific to your AWS setup.

License
This script is licensed under the MIT License.

You can save this content to a file named `README.md` in your Git repository, and it will serve as the README for your project.