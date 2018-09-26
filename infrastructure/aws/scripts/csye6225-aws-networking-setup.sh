#!/bin/bash
#***********************************************************************************
#    AWS VPC Creation Shell Script
#***********************************************************************************
#
# SYNOPSIS
#    Automates the creation of a custom IPv4 VPC, having public subnet, Internet
#    gateway aTtached to VPC and Route tables
#
# DESCRIPTION
#    This shell script leverages the AWS Command Line Interface (AWS CLI) to
#    automatically create a custom VPC.
#
#===================================================================================
echo Enter the name of the VPC
read VPC_NAME

echo Enter the IP address for VPC in x.x.x.x/x format
read VPC_CIDR

AWS_REGION="us-east-2"
ZONE1="us-east-2a"
ZONE2="us-east-2b"
ZONE3="us-east-2c"

#***********************************************************************************
#Creating a new VPC
#***********************************************************************************
echo "Creating '$VPC_NAME' in '$AWS_REGION' with $VPC_CIDR IP Address……."

VPC_ID=$(aws ec2 create-vpc \
  --cidr-block $VPC_CIDR \
  --query 'Vpc.{VpcId:VpcId}' \
  --output text )
if [ $? -ne "0" ]
then
  echo "Creation of VPC failed...."
  exit 1
else
  echo "  VPC ID '$VPC_ID' CREATED in '$AWS_REGION' region."
fi

#***********************************************************************************
# Create Internet gateway
#***********************************************************************************
echo "Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway \
  --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' \
  --output text )
if [ $? -ne "0" ]
then
  echo "Creation of Internet Gateway failed...."
  exit 1
else
  echo "  Internet Gateway ID '$IGW_ID' CREATED."
fi

#***********************************************************************************
# Attach Internet gateway to your VPC
#***********************************************************************************
echo "Attaching internet gateway "$IGW_ID" to VPC "$VPC_ID" "
aws ec2 attach-internet-gateway \
  --vpc-id $VPC_ID \
  --internet-gateway-id $IGW_ID

if [ $? -ne "0" ]
then
  echo "Attaching Internet gateway to VPC failed...."
  exit 1
else
  echo "  Internet Gateway ID '$IGW_ID' ATTACHED to VPC ID '$VPC_ID'."
fi

#***********************************************************************************
#echo "Please provide Availability zones for subnet 1"
#***********************************************************************************

echo "Please provide IP Address for public subnet 1 in x.x.x.x/x"
read SUBNET1

SUBNET_1=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET1 \
  --availability-zone $ZONE1 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)

echo  "Subnet ID '$SUBNET_1' is created in '$ZONE1'" "Availability Zone."

echo "Please provide IP Address for public subnet 2 in x.x.x.x/x"
read SUBNET2

#echo "Please provide Availability zones for subnet 1"


SUBNET_2=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET2 \
  --availability-zone $ZONE2 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)

echo  "Subnet ID '$SUBNET_2' is created in '$ZONE2'" "Availability Zone."

echo "Please provide IP Address for public subnet 3 in x.x.x.x/x"
read SUBNET3

#echo "Please provide Availability zones for subnet 1"


SUBNET_3=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET3 \
  --availability-zone $ZONE3 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)

echo  "Subnet ID '$SUBNET_3' is created in '$ZONE3'" "Availability Zone."

#***********************************************************************************
#create private subnet
#***********************************************************************************

echo "Please provide IP Address for PRIVATE subnet 1 in x.x.x.x/x"
read PRIVATE_SUBNET1

#echo "Please provide Availability zones for subnet 1"


PRIVATE_SUBNET_1=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $PRIVATE_SUBNET1 \
  --availability-zone $ZONE1 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)

echo  "Subnet ID '$PRIVATE_SUBNET_1' is created in '$ZONE1'" "Availability Zone."

echo "Please provide IP Address for PRIVATE subnet 2 in x.x.x.x/x"
read PRIVATE_SUBNET2

#echo "Please provide Availability zones for subnet 1"


PRIVATE_SUBNET_2=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $PRIVATE_SUBNET2 \
  --availability-zone $ZONE2 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)

echo  "Subnet ID '$PRIVATE_SUBNET_2' is created in '$ZONE2'" "Availability Zone."

echo "Please provide IP Address for PRIVATE subnet 3 in x.x.x.x/x"
read PRIVATE_SUBNET3

#echo "Please provide Availability zones for subnet 1"


PRIVATE_SUBNET_3=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $PRIVATE_SUBNET3 \
  --availability-zone $ZONE3 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)

echo  "Subnet ID '$PRIVATE_SUBNET_3' is created in '$ZONE3'" "Availability Zone."

#***********************************************************************************
# Create Route Table
#***********************************************************************************
echo "Creating Route Table..."
ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --query 'RouteTable.{RouteTableId:RouteTableId}' \
  --output text )
if [ $? -ne "0" ]
then
  echo "Creating ROUTE_TABLE failed...."
  exit 1
else
  echo "  Route Table ID '$ROUTE_TABLE_ID' CREATED."
fi

#***********************************************************************************
# Create route to Internet Gateway
#***********************************************************************************

echo "kindly provide route (0.0.0.0/0) to Internet gateway"
read ALL_ROUTE

Route=$(aws ec2 create-route \
  --route-table-id $ROUTE_TABLE_ID \
  --destination-cidr-block $ALL_ROUTE \
  --gateway-id $IGW_ID )
if [ $? -ne "0" ]
then
  echo "Providing Route to Internet gateway failed...."
  exit 1
else
  echo "  Route $ALL_ROUTE is added with Internet Gateway ID '$IGW_ID' to" \
  "Route Table ID '$ROUTE_TABLE_ID'."
fi

#***********************************************************************************
# Associate Public Subnet with Route Table
#***********************************************************************************
Associate1=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_1 \
  --route-table-id $ROUTE_TABLE_ID \
  --region $AWS_REGION)
echo "  Public Subnet ID '$SUBNET_1' ASSOCIATED with Route Table ID" \
  "'$ROUTE_TABLE_ID'."

Associate2=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_2 \
  --route-table-id $ROUTE_TABLE_ID \
  --region $AWS_REGION)
echo "  Public Subnet ID '$SUBNET_2' ASSOCIATED with Route Table ID" \
  "'$ROUTE_TABLE_ID'."

Associate3=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_3 \
  --route-table-id $ROUTE_TABLE_ID \
  --region $AWS_REGION)
echo "  Public Subnet ID '$SUBNET_3' ASSOCIATED with Route Table ID" \
  "'$ROUTE_TABLE_ID'."

#***********************************************************************************
# Associate PRIVATE Subnet with Route Table
#***********************************************************************************

#PRIVATE_Associate1=$(aws ec2 associate-route-table  \
#  --subnet-id $PRIVATE_SUBNET_1 \
#  --route-table-id $ROUTE_TABLE_ID \
#  --region $AWS_REGION)
#echo "  Private Subnet ID '$SUBNET_1' ASSOCIATED with Route Table ID" \
#  "'$ROUTE_TABLE_ID'."

#PRIVATE_Associate2=$(aws ec2 associate-route-table  \
#  --subnet-id $PRIVATE_SUBNET_2 \
#  --route-table-id $ROUTE_TABLE_ID \
#  --region $AWS_REGION)
#echo "  Private Subnet ID '$SUBNET_2' ASSOCIATED with Route Table ID" \
#  "'$ROUTE_TABLE_ID'."

#PRIVATE_Associate3=$(aws ec2 associate-route-table  \
#  --subnet-id $PRIVATE_SUBNET_3 \
#  --route-table-id $ROUTE_TABLE_ID \
#  --region $AWS_REGION)
#echo "  Private Subnet ID '$SUBNET_3' ASSOCIATED with Route Table ID" \
#  "'$ROUTE_TABLE_ID'."
