# Udacity Nanodegree - AWS Cloud Architect - Design, Provision and Monitor AWS Infrastructure at Scale

## Project Instructions
### Exercise 1
In the main.tf file write the code to provision
AWS as the cloud provider
Use an existing VPC ID
Use an existing public subnet
4 AWS t2.micro EC2 instances named Udacity T2
2 m4.large EC2 instances named Udacity M4
Run Terraform.
Take a screenshot of the 6 EC2 instances in the AWS console and save it as Terraform_1_1.
Use Terraform to delete the 2 m4.large instances
Take an updated screenshot of the AWS console showing only the 4 t2.micro instances and save it as Terraform_1_2
### Exercise 2
In the Exercise_2 folder, write the code to deploy an AWS Lambda Function using Terraform. Your code should include:

A lambda.py file
A main.tf file with AWS as the provider, and IAM role for Lambda, a VPC, and a public subnet
An outputs.tf file
A variables.tf file with an AWS region
Take a screenshot of the EC2 instances page

Take a screenshot of the VPC page

## Installation
### Prerequisites
- [AWS CLI](https://aws.amazon.com/cli/)
- [Terraform](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform)