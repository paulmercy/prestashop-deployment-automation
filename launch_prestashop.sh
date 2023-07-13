#!/bin/bash

# Define variables
REGION="us-east-2"
APP_INSTANCE_TYPE="t2.micro"
DB_INSTANCE_TYPE="t2.micro"
SUBNET_ID="subnet-xxxxxxxxxxxxxxx"
APP_SG_ID="sg-xxxxxxxxxxxxxx"
DB_SG_ID="sg-xxxxxxxxxxxxxx"
KEY_NAME="Mykeypair"
APP_USER_DATA="app_startup_script.sh"
DB_USER_DATA="db_startup_script.sh"
PRESTASHOP_VERSION="1.7.7.0"

# Launch the application server instance
APP_INSTANCE_ID=$(aws ec2 run-instances \
  --image-id ami-069d73f3235b535bd \
  --instance-type $APP_INSTANCE_TYPE \
  --subnet-id $SUBNET_ID \
  --security-group-ids $APP_SG_ID \
  --key-name $KEY_NAME \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=PrestaShopAppInstance}]" \
  --user-data fileb://$APP_USER_DATA \
  --output text --query 'Instances[0].InstanceId')

echo "Application server instance $APP_INSTANCE_ID is being created..."

# Wait for the application server instance to be running
aws ec2 wait instance-running --instance-ids $APP_INSTANCE_ID
echo "Application server instance $APP_INSTANCE_ID is now running."

# Retrieve the public DNS name of the application server instance
APP_PUBLIC_DNS=$(aws ec2 describe-instances --instance-ids $APP_INSTANCE_ID --region $REGION \
  --output text --query 'Reservations[0].Instances[0].PublicDnsName')

echo "PrestaShop is being installed on the application server ($APP_PUBLIC_DNS)..."

# Launch the database server instance
DB_INSTANCE_ID=$(aws ec2 run-instances \
  --image-id ami-069d73f3235b535bd \
  --instance-type $DB_INSTANCE_TYPE \
  --subnet-id $SUBNET_ID \
  --security-group-ids $DB_SG_ID \
  --key-name $KEY_NAME \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=PrestaShopDBInstance}]" \
  --user-data fileb://$DB_USER_DATA \
  --output text --query 'Instances[0].InstanceId')

echo "Database server instance $DB_INSTANCE_ID is being created..."

# Wait for the database server instance to be running
aws ec2 wait instance-running --instance-ids $DB_INSTANCE_ID
echo "Database server instance $DB_INSTANCE_ID is now running."

# Retrieve the public DNS name of the database server instance
DB_PUBLIC_DNS=$(aws ec2 describe-instances --instance-ids $DB_INSTANCE_ID --region $REGION \
  --output text --query 'Reservations[0].Instances[0].PublicDnsName')

echo "PrestaShop is being installed on the database server ($DB_PUBLIC_DNS)..."

# Wait for SSH to be available on the application server
until ssh -o StrictHostKeyChecking=no -i path/Mykeypair.pem ec2-user@$APP_PUBLIC_DNS 'echo "SSH is ready"'; do
  sleep 5
done

# Access the application server via SSH and update the configuration file
ssh -i path/Mykeypair.pem ec2-user@$APP_PUBLIC_DNS <<EOF

# Update the PrestaShop configuration file with the database server details
sudo sed -i "s/localhost/$DB_PUBLIC_DNS/" /var/www/html/app/config/parameters.php

EOF

echo "PrestaShop installation is complete. Access the application at http://$APP_PUBLIC_DNS"
echo "Database server: $DB_PUBLIC_DNS"


# NOTE to run the script first Make the shell script file executable by running the following command:
#    chmod +x launch_prestashop.sh
# Run the shell script by executing the following command:
#    ./launch_prestashop.sh
