import boto3
session1 = boto3.client('ec2',region_name='us-east-1')

response = session1.copy_image(
   Name='DevEnv_Linux',
   Description='Copied this AMI from region eu-west-2',
   SourceImageId='ami-01729f3720ef9d288',
   SourceRegion='eu-west-2'
)