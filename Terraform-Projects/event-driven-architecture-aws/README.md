# Event driven AWS Infrastructure with Terraform

## **Introduction**

This repository contains Terraform code for creating and managing AWS resources for event driven architecture.This code creates lambdas ,sqs and sns using loop and then sets lambdas as target of sqs queues.

## **Prerequisites**+

Before you can use the code in this repository, you will need to have the following tools and dependencies installed:

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

## Configure AWS Credentials

Run following commands to configure aws credentials on your system

    aws configure --profile <PROFILE_NAME>

Enter `aws_access_key_id`, `secret_access_key`, `region` and `output` (json).
Note: You will have to replace your `profile` name in the providers.tf file of each directory with your created profile. 
## **Getting started**

Now use the following command to go to the directory (like BE-mod or FE-mod) you want to work with using terraform.

    cd <directory-name>

Now initialize the terraform using following command

    terraform init

After this we have to check the Terraform Workspace we are currently in and change to the respective Workspace using command.

    terraform workspace select <env>

    terraform validate

After validating, check which resources are being updated, created or destroyed using the following command.

    terraform plan 

If all the changes displayed look good, use the following command to apply these changes.

    terraform apply 

