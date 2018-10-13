{
    "AWSTemplateFormatVersion": "2010-09-09",
    "Description": "AWS CloudFormation Sample Template Ec2instance, DBinstances With SecurityGroup",
    "Parameters": {
        "KeyName": {
            "Description": "Name of an existing EC2 KeyPair to enable SSH access to the instance",
            "Type": "AWS::EC2::KeyPair::KeyName",
            "ConstraintDescription": "Existing or Newly created EC2 KeyPair"
        },
        "InstanceType": {
            "Description": "EC2 instance type.",
            "Type": "String",
            "Default": "t2.micro"
        },

        "VPC": {
            "Description": "VPC.",
            "Type": "String"
        },

        "SSHLocation": {
            "Description": "The IP address range that can be used to ssh/ https to the EC2 instances",
            "Type": "String",
            "MinLength": "9",
            "MaxLength": "18",
            "AllowedPattern": "(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})",
            "ConstraintDescription": "must be a valid IP CIDR range of the form x.x.x.x/x."
        },

        "SubnetId": {
            "Description": "Public SubnetId in VPC ",
            "Type": "String"
        },

        "SubnetId1": {
            "Description": "Private SubnetId in RDS instance",
            "Type": "String"
        },

        "SubnetId2": {
            "Description": "Private SubnetId in RDS instance",
            "Type": "String"
        },

        "HostedZone" : {
            "Type" : "String",
            "Description" : "The DNS name of an existing Amazon Route 53 hosted zone",
            "AllowedPattern" : "(?!-)[a-zA-Z0-9-.]{1,63}(?<!-)",
            "ConstraintDescription" : "must be a valid DNS zone name."
          },

        "HashKeyElementName" : {
            "Description" : "HashType PrimaryKey Name",
            "Type" : "String",
            "AllowedPattern" : "[a-zA-Z0-9]*",
            "MinLength": "1",
            "MaxLength": "2048",
            "ConstraintDescription" : "must contain only alphanumberic characters"
          },
      
        "HashKeyElementType" : {
            "Description" : "HashType PrimaryKey Type",
            "Type" : "String",
            "Default" : "S",
            "AllowedPattern" : "[S|N]",
            "MinLength": "1",
            "MaxLength": "1",
            "ConstraintDescription" : "must be either S or N"
          },
      
        "ReadCapacityUnits" : {
            "Description" : "Provisioned read throughput",
            "Type" : "Number",
            "Default" : "5",
            "MinValue": "5",
            "MaxValue": "10000",
            "ConstraintDescription" : "must be between 5 and 10000"
          },
      
        "WriteCapacityUnits" : {
            "Description" : "Provisioned write throughput",
            "Type" : "Number",
            "Default" : "5",
            "MinValue": "5",
            "MaxValue": "10000",
            "ConstraintDescription" : "must be between 5 and 10000"
          },

        "TableName" :{
              "Description" : "Name of the DynamoDB Table",
              "Type" : "String"
          },

        "DBUser": {
            "NoEcho": "true",
            "Description" : "The database admin account username",
            "Type": "String",
            "MinLength": "1",
            "MaxLength": "16",
            "AllowedPattern" : "[a-zA-Z][a-zA-Z0-9]*",
            "ConstraintDescription" : "must begin with a letter and contain only alphanumeric characters."
          },
      
        "DBPassword": {
            "NoEcho": "true",
            "Description" : "The database admin account password",
            "Type": "String",
            "MinLength": "8",
            "MaxLength": "41",
            "AllowedPattern" : "[a-zA-Z0-9]*",
            "ConstraintDescription" : "must contain only alphanumeric characters."
          },

        "DBInstanceClass": {
              "Description" : "The database instance type",
              "Type": "String",
              "Default": "db.t2.medium",
              "AllowedValues" : [ "db.t2.medium"],
              "ConstraintDescription" : "must select a valid database instance type."
            },

        "S3Bucket": {
                "Description" : "The database instance type",
                "Type": "String"
              },

        "MultiAZ" : {
              "Description" : "Multi-AZ master database",
              "Type" : "String",
              "Default" : "false",
              "AllowedValues" : [ "true", "false" ],
              "ConstraintDescription" : "must be true or false."
            },

        "PubliclyAccessible" : {
              "Description" : "PubliclyAccessible or not",
              "Type" : "String",
              "Default" : "false",
              "AllowedValues" : [ "true", "false" ],
              "ConstraintDescription" : "must be true or false."
            },

        "DBInstanceIdentifier" : {
            "Type" : "String"
            },

        "DBName" : {
            "Type":"String"
            },

        "Subnetgroupname":{
            "Description" : "DB subnet group",
            "Type" : "String"
            }
        
    },
    "Mappings": {
        "AWSInstanceType2Arch": {
            "t2.micro": {
                "Arch": "HVM64"
            }
        },
        "AWSRegionArch2AMI": {
            "us-east-1": {
                "HVM64": "ami-9887c6e7"
            }
        }
    },

    "Conditions" : {
        "Is-EC2-VPC"     : {"Fn::Equals" : [{"Ref" : "AWS::Region"}, "us-east-1" ]}
      },


    "Resources": {
        "EC2Instance": {
            "Type": "AWS::EC2::Instance",
            "Properties": {
                "ImageId": {
                    "Fn::FindInMap": [
                        "AWSRegionArch2AMI",
                        {
                            "Ref": "AWS::Region"
                        },
                        {
                            "Fn::FindInMap": [
                                "AWSInstanceType2Arch",
                                {
                                    "Ref": "InstanceType"
                                },
                                "Arch"
                            ]
                        }
                    ]
                },
                "InstanceType": {
                    "Ref": "InstanceType"
                },
                "BlockDeviceMappings": [
                    {
                    "DeviceName" : "/dev/sda1",
                    "Ebs": {
                            "VolumeSize": "20",
                            "DeleteOnTermination": "true",
                            "VolumeType": "gp2"
                        }
                    }],
                "KeyName": {
                    "Ref": "KeyName"
                },
                "NetworkInterfaces": [
                    {
                        "AssociatePublicIpAddress": "true",
                        "DeviceIndex": "0",
                        "GroupSet": [{"Ref": "SecurityGroupBySG"}],
                        "SubnetId": {"Ref": "SubnetId"}
                    }
                ],
                "Tags": [
                    {
                      "Key": "Name",
                      "Value": {
                        "Fn::Join": ["",[{"Ref": "AWS::StackName"},"-csye6225-ec2"]]
                      }
                    }
                ]
            }
        },

        "myDynamoDBTable" : {
            "Type" : "AWS::DynamoDB::Table",
            "Properties" : {
              "AttributeDefinitions": [ { 
                "AttributeName" : {"Ref" : "HashKeyElementName"},
                "AttributeType" : {"Ref" : "HashKeyElementType"}
              } ],
              "KeySchema": [
                { "AttributeName": {"Ref" : "HashKeyElementName"}, "KeyType": "HASH" }
              ],
              "ProvisionedThroughput" : {
                "ReadCapacityUnits" : {"Ref" : "ReadCapacityUnits"},
                "WriteCapacityUnits" : {"Ref" : "WriteCapacityUnits"}
              },
              "TableName" : "csye6225"              
            }
          },

          "myDB" : {
            "Type" : "AWS::RDS::DBInstance",
            "Properties" : {
              "AllocatedStorage" : "5",
              "DBInstanceClass" : { "Ref" : "DBInstanceClass" },
              "DBInstanceIdentifier" : {"Ref" : "DBInstanceIdentifier"},
              
              "DBSubnetGroupName" : {"Ref":"myDBSubnetGroup"},
              "Engine" : "MySQL",
              "MultiAZ" : { "Ref" : "MultiAZ" },
              "MasterUsername" : { "Ref" : "DBUser" },
              "MasterUserPassword" : { "Ref" : "DBPassword" },
              "PubliclyAccessible" :{ "Ref" : "PubliclyAccessible" },
              "VPCSecurityGroups": { "Fn::If" : [ "Is-EC2-VPC", [ { "Fn::GetAtt": [ "DBSecurityGroup", "GroupId" ] } ], { "Ref" : "AWS::NoValue"}]},
              "DBName" : { "Ref" : "DBName" }
              
              
              
            }
          },
          
          "myDBSubnetGroup" : {
            "Type" : "AWS::RDS::DBSubnetGroup",
            "Properties" : {
               "DBSubnetGroupDescription" : "description",
               "SubnetIds" : [{"Ref":"SubnetId1"},{"Ref":"SubnetId2"}]
               
            }
         },

        "MyDNSRecord" : {
            "Type" : "AWS::Route53::RecordSet",
            "Properties" : {
              "HostedZoneName" : { "Fn::Join" : [ "", [{"Ref" : "HostedZone"}, "." ]]},
              "Comment" : "DNS name for my instance.",
              "Name" : { "Fn::Join" : [ "", [{"Ref" : "EC2Instance"}, ".", {"Ref" : "AWS::Region"}, ".", {"Ref" : "HostedZone"} ,"."]]},
              "Type" : "TXT",
              "TTL" : "60",
              "ResourceRecords" : ["\"csye-6225-fall2018\""]
            }
        },

        "SecurityGroupBySG" : {
            "Type" : "AWS::EC2::SecurityGroup",
            "Properties" : {
                "GroupDescription" : "allow connections from specified source security group",
                "VpcId" : {"Ref" : "VPC"},
                "SecurityGroupIngress" : [
                    {
                       "IpProtocol" : "tcp",
                       "FromPort" : "22",
                       "ToPort" : "22",
                       "CidrIp" : { "Ref" : "SSHLocation"}
                    },
                    { "IpProtocol" : "tcp", 
                     "FromPort" : "80",
                     "ToPort" : "80", 
                     "CidrIp" : { "Ref" : "SSHLocation"}
                    },
                    { "IpProtocol" : "tcp", 
                        "FromPort" : "443",
                        "ToPort" : "443", 
                        "CidrIp" : { "Ref" : "SSHLocation"}
                    }
                    
                ],
                "Tags": [
                  {
                    "Key": "Name",
                    "Value": {"Fn::Join": ["",[{"Ref": "AWS::StackName"},"-csye6225-webapp"]]}
                  }
                ]
            }
           },

           "s3bucket": {
            "Type": "AWS::S3::Bucket",
            "Properties": {
                "BucketName":  {"Ref" :"S3Bucket"}
            }
            },


           "DBSecurityGroup": {
            "Type": "AWS::EC2::SecurityGroup",
            "Condition" : "Is-EC2-VPC",
            "Properties": {
                "GroupDescription" : "allow connections from specified source security group and ec2 Security group",
                "VpcId" : {"Ref" : "VPC"},
               "SecurityGroupIngress": [
                {
                    "IpProtocol" : "tcp",
                    "FromPort" : "3306",
                    "ToPort" : "3306",
                    "SourceSecurityGroupId" : { "Ref": "SecurityGroupBySG"}
                 }
               ],
               "Tags": [
                {
                  "Key": "Name",
                  "Value": {"Fn::Join": ["",[{"Ref": "AWS::StackName"},"-csye6225-rds"]]}
                }
              ]
            }
         }
    },

    "Outputs" : {
        "JDBCConnectionString": {
          "Description" : "JDBC connection string for the database",
          "Value" : { "Fn::Join": [ "", [ "jdbc:mysql://",
                                          { "Fn::GetAtt": [ "myDB", "Endpoint.Address" ] },
                                          ":",
                                          { "Fn::GetAtt": [ "myDB", "Endpoint.Port" ] },
                                          "/",
                                          { "Ref": "DBName" }]]}
        }
      }
}
