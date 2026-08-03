#!/bin/bash
DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo
echo "Running create-instance.sh at "$DATE
echo

# Fixed values
instanceType="t3.small"
echo "Instance type: "$instanceType
profile="default"
echo "Profile: "$profile

echo
echo "Looking up account values..."

# get vpcId
vpc=""
while [[ "$vpc" == "" ]]; do
for i in $(aws ec2 describe-regions | grep RegionName | cut -d '"' -f4); do
region=$i;
vpc=$(aws ec2 describe-vpcs --region $i --filters "Name=tag:Name,Values='Cafe VPC'" --profile $profile | grep VpcId | cut -d '"' -f4 | sed -n 1p );
if [[ "$vpc" != "" ]]; then
break;
fi
done
done
echo
echo "VPC: "$vpc
echo "Region: "$region

# get subnetId
subnetId=$(aws ec2 describe-subnets \
--filters "Name=tag:Name,Values='Cafe Public Subnet 1'" \
--region $region \
--profile $profile \
--query "Subnets[*]" | grep SubnetId | cut -d '"' -f4 | sed -n 1p)
echo "Subnet Id: "$subnetId

# Get key pair name
key=$(aws ec2 describe-key-pairs \
--profile $profile --region $region | grep KeyName | cut -d '"' -f4 )
echo "Key: "$key

# Get AMI Id
imageId=$(aws ssm get-parameters \
--names '/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2' \
--profile $profile \
--region $region | grep ami- | cut -d '"' -f4 | sed -n 2p)
echo "Image Id: "$imageId

#check for existing cafe instance
existingEc2Instance=$(aws ec2 describe-instances \
--region $region \
--profile $profile \
--filters "Name=tag:Name,Values=cafeserver" "Name=instance-state-name,Values=running" \
| grep InstanceId | cut -d '"' -f4)
if [[ "$existingEc2Instance" != "" ]]; then
echo
echo "WARNING: Found existing EC2 instance with Id "$existingEc2Instance"."
echo "This script will not run successfully if it already exists."
echo "Do you want to delete it? [Y/N]"
echo ">>"

validResp=0
while [ $validResp -eq 0 ];
do
read answer
if [[ "$answer" == "Y" || "$answer" == "y" ]]; then
echo
echo "Deleting existing instance..."
aws ec2 terminate-instances --instance-ids $existingEc2Instance --region $region --profile $profile
#wait for confirmation it has terminated
aws ec2 wait instance-terminated --instance-ids $existingEc2Instance --region $region --profile $profile
validResp="1"
elif [[ "$answer" == "N" || "$answer" == "n" ]]; then
echo "Ok, exiting."
exit 1
else
echo "Please respond with Y or N."
fi
done

sleep 10 #give 10 seconds before attempting to delete the SG used by this instance.
fi

#check for existing cafeSG security group
existingMpSg=$(aws ec2 describe-security-groups \
--region $region \
--query "SecurityGroups[?contains(GroupName, 'cafeSG')]" \
--profile $profile | grep GroupId | cut -d '"' -f4)

if [[ "$existingMpSg" != "" ]]; then
echo
echo "WARNING: Found existing security group with name "$existingMpSg"."
echo "This script will not run successfully if it already exists."
echo "Do you want to delete it? [Y/N]"
echo ">>"

validResp=0
while [ $validResp -eq 0 ];
do
read answer
if [[ "$answer" == "Y" || "$answer" == "y" ]]; then
echo
echo "Deleting existing security group..."
aws ec2 delete-security-group --group-id $existingMpSg --region $region --profile $profile
validResp="1"
elif [[ "$answer" == "N" || "$answer" == "n" ]]; then
echo "Ok, exiting."
exit 1
else
echo "Please respond with Y or N."
fi
done
sleep 10 #give 10 seconds before attempting to recreate the SG
fi

# CREATE a security group and capture its name
echo
echo "Creating a new security group..."
securityGroup=$(aws ec2 create-security-group --group-name "cafeSG" \
--description "cafeSG" \
--region $region \
--profile $profile \
--vpc-id $vpc | grep GroupId | cut -d '"' -f4 )
echo "Security Group: "$securityGroup

# Open ports on the security group
echo
echo "Opening port 22 on the new security group"
aws ec2 authorize-security-group-ingress \
--group-id $securityGroup \
--protocol tcp \
--port 22 \
--cidr 0.0.0.0/0 \
--region $region \
--profile $profile

echo "Opening port 80 on the new security group"
aws ec2 authorize-security-group-ingress \
--group-id $securityGroup \
--protocol tcp \
--port 80 \
--cidr 0.0.0.0/0 \
--region $region \
--profile $profile

echo
echo "Creating an EC2 instance in "$region
instanceDetails=$(aws ec2 run-instances \
--image-id $imageId \
--count 1 \
--instance-type $instanceType \
--region $region \
--subnet-id $subnetId \
--security-group-ids $securityGroup \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=cafeserver}]' \
--associate-public-ip-address \
--iam-instance-profile Name=LabInstanceProfile \
--profile $profile \
--user-data file://create-lamp-instance-userdata-v2.txt \
--key-name $key )

#If the create instance command fails, exit this script.
if [[ "$?" -ne "0" ]]; then
exit
fi

echo
echo "Instance details..."
echo $instanceDetails | python -m json.tool

# Extract instance Id
instanceId=$(echo $instanceDetails | python -m json.tool | grep InstanceId | sed -n 1p | cut -d '"' -f4)
echo "instanceId="$instanceId
echo
echo "Waiting for a public IP for the new instance..."
pubIp=""
while [[ "$pubIp" == "" ]]; do
sleep 10;
pubIp=$(aws ec2 describe-instances --instance-id $instanceId --region $region --profile $profile | grep PublicIp | sed -n 1p | cut -d '"' -f4)
done

echo
echo "The public IP address for your LAMP instance is: "$pubIp
echo
echo "Download the key pair from the Vocareum page."
echo
echo "Then, connect using this command (with .pem or .ppk appended to the end of the key name):"
echo "ssh -i path-to/"$key"ec2-user@"$pubIp
echo
echo "The site should also be available at"
echo "http://"$pubIp"/cafe/"

echo
DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo
echo "Execution of create-instance.sh completed at "$DATE
echo
