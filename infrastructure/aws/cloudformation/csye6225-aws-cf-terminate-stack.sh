#====================================================================================================
# Synopsis: This script is used to terminate Custom VPC having Route-Table, Internet Gateway 
# and Subnet in CloudFormation Stack
#====================================================================================================
#Displaying the stacks
#====================================================================================================

StackList=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_IN_PROGRESS CREATE_IN_PROGRESS --query 'StackSummaries[].StackName' --output text )
if [[ -z "$StackList" ]]
then
  echo "There is no Stack available to delete" 
  exit 1
else
  echo "Enter stack Name to be deleted from the list"
  echo $StackList
  read StackName
  echo "Deleting the stack $StackName"
fi

#====================================================================================================
#Termination of the stack using Parameter File
#====================================================================================================

Delete=$(aws cloudformation delete-stack --stack-name $StackName)
if [ $? -ne "0" ]
then
  echo "$StackName stack is not deleted....."
  echo "$Delete"
  exit 1
else
  echo "Deletion in Progress....."
fi

#====================================================================================================
# Waiting for the stack to get created completely
#====================================================================================================

Success=$(aws cloudformation wait stack-delete-complete --stack-name $StackName)
if [[ -z "$Success" ]]
then
  echo "$StackName stack is deleted successfully"
else
  echo "Deletion of $StackName stack failed."
  echo "$Success"
  exit 1
fi