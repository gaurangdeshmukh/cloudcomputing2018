#!/bin/bash
#====================================================================================================
# Synopsis: This script is used to create CentOS ec2 instances with security group and Route 53
# in CloudFormation Stack
#====================================================================================================
# Creation of Elastic Compute Cloud stacks
#====================================================================================================
echo "Enter Stack Name for the creation of CI/CD Stack"
read sn
echo ""

#====================================================================================================
# Validating the CloudFormation Template
#====================================================================================================

Valid=$(aws cloudformation  validate-template --template-body file://csye6225-cf-cicd.json)
if [ $? -ne "0" ]
then
  echo "$Valid"
  echo "$StackName Template file to build infrastructure is NOT VALID....."
  exit 1
else
  echo " Proceed ahead. CloudFormation Template is VALID......"
  echo ""
fi


#====================================================================================================
# Obtaining Hosted Zone ID and zones
#====================================================================================================
ID=$(aws route53 list-hosted-zones --query HostedZones[].{Id:Id} --output text|cut -d"/" -f3 2>&1)
echo "Route53 Hosted Id is: $ID"
echo ""

HostedZoneName=$(aws route53 list-hosted-zones --query HostedZones[].{Name:Name} --output text | sed 's/.$//' 2>&1)
echo "Route53 Hosted Name is: $HostedZoneName"
echo ""

HostedZoneName1=$(aws route53 list-hosted-zones --query HostedZones[].{Name:Name} --output text)
com="csye6225.com"
BucketName=$HostedZoneName1$com

#====================================================================================================
#Creation of the stack using Parameter File
#====================================================================================================
export TravisUser=travis
create=$(aws cloudformation create-stack --stack-name $sn --template-body file://csye6225-cf-cicd.json --capabilities CAPABILITY_NAMED_IAM \
  --parameters ParameterKey=DeployBucket,ParameterValue=code-deploy.$HostedZoneName.csye6225.com \
  ParameterKey=TravisUser,ParameterValue=$TravisUser ParameterKey=AttachBucket,ParameterValue=$BucketName)

if [ $? -ne "0" ]
then
  echo "Creation of $sn stack failed...."
  exit 1
else
  echo "Creation of $sn is in progress......"
fi

#====================================================================================================
# Waiting for the stack to get created completely
#====================================================================================================

echo Stack in progress.....
Success=$(aws cloudformation wait stack-create-complete --stack-name $sn)

if [[ -z "$Success" ]]
then
  echo "$StackName stack is created successfully. Printing output..."
else
  echo "Creation of $StackName stack failed. Printing error and exiting....."
  echo "$Success"
  exit 1
fi
