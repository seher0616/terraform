#  Terraform-01 : Terraform Installation and Basic Operations:

Purpose of the this hands-on training is to give  the knowledge of basic operations in Terraform.

## Learning Outcomes

At the end of the this hands-on training,  will be able to;

- Install Terraform

- Build AWS Infrastructure with Terraform

## Outline

- Part 1 - Install Terraform

- Part 2 - Build AWS Infrastructure with Terraform

## Terraform Commands

-  Create a directory ("terraform-aws") for the new configuration and change into the directory.

```bash
$ mkdir terraform-aws && cd terraform-aws && touch main.tf


```bash

- Add any subcommand to terraform -help to learn more about what it does and available options.


terraform -help apply
or
terraform apply -help
```

## Part 2 - Build AWS Infrastructure with Terraform

### Prerequisites

- An AWS account.

- The AWS CLI installed. 

- Your AWS credentials configured locally. 

```bash
aws configure
```

- Hard-coding credentials into any Terraform configuration is not recommended, and risks secret leakage should this file ever be committed to a public version control system. Using AWS credentials in EC2 instance is not recommended.

- We will use IAM role (temporary credentials) for accessing your AWS account. 

### Create a role in IAM management console.

- Secure way to make API calls is to create a role and assume it. It gives temporary credentials for access your account and makes API calls.

- Go to the IAM service, click "roles" in the navigation panel on the left then click "create role". 

- Under the use cases, Select `EC2`, click "Next Permission" button.

- In the search box write EC2 and select `AmazonEC2FullAccess` then click "Next: Tags" and "Next: Reviews".

- Name it `terraform`.

- Attach this role to your EC2 instance. 

### Write your first configuration

- The set of files used to describe infrastructure in Terraform is known as a Terraform configuration. You'll write your first configuration file to launch a single AWS EC2 instance.

- Each configuration should be in its own directory. Create a directory ("terraform-aws") for the new configuration and change into the directory.




- Install the `HashiCorp Terraform` extension in VSCode.

- Create a file named `main.tf` for the configuration code and copy and paste the following content. 

```t

provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.8.0"
    }
  }
}

resource "aws_instance" "tf-ec2" {
  ami           = "ami-0ed9277fb7eb570c9"
  instance_type = "t2.micro"
  key_name      = "seherSon"    # write your pem file without .pem extension>
  tags = {
    "Name" = "tf-ec2"
  }
}

resource "aws_s3_bucket" "tf-s3" {
  bucket = "seher-tf-test-bucket-addwhateveryouwant"
}
```

- Explain the each block via the following section.



### Initialize the directory

When you create a new configuration you need to initialize the directory with `terraform init`.

- Initialize the directory.

```bash
terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "3.69.0"...
- Installing hashicorp/aws v3.9.0...
- Installed hashicorp/aws v3.9.0 (signed by HashiCorp)

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Terraform downloads the `aws` provider and installs it in a hidden subdirectory (.terraform) of the current working directory. The output shows which version of the plugin was installed.

- Show the `.terraform` folder and inspect it.

### Create infrastructure

- Run `terraform plan`. You should see an output similar to the one shown below.

```bash
terraform plan

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.sample-resource will be created
  + resource "aws_instance" "tf-ec2" {
      + ami                          = "ami-04d29b6f966df1537"
      + arn                          = (known after apply)
      + associate_public_ip_address  = (known after apply)
      + availability_zone            = (known after apply)
      + cpu_core_count               = (known after apply)
      + cpu_threads_per_core         = (known after apply)
      + get_password_data            = false
      + host_id                      = (known after apply)
      + id                           = (known after apply)
      + instance_state               = (known after apply)
      + instance_type                = "t2.micro"
      + ipv6_address_count           = (known after apply)
      + ipv6_addresses               = (known after apply)
      + key_name                     = (known after apply)
      + network_interface_id         = (known after apply)
      + outpost_arn                  = (known after apply)
      + password_data                = (known after apply)
      + placement_group              = (known after apply)
      + primary_network_interface_id = (known after apply)
      + private_dns                  = (known after apply)
      + private_ip                   = (known after apply)
      + public_dns                   = (known after apply)
      + public_ip                    = (known after apply)
      + security_groups              = (known after apply)
      + source_dest_check            = true
      + subnet_id                    = (known after apply)
      + tenancy                      = (known after apply)
      + volume_tags                  = (known after apply)
      + vpc_security_group_ids       = (known after apply)

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform can't guarantee that exactly these actions will be performed if "terraform apply" is subsequently run.
```

- This output shows the execution plan, describing which actions Terraform will take in order to change real infrastructure to match the configuration. 

- Run `terraform apply`. You should see an output similar to the one shown above.

```bash
terraform apply
```

- Terraform will wait for your approval before proceeding. If anything in the plan seems incorrect it is safe to abort (ctrl+c) here with no changes made to your infrastructure.

- If the plan is acceptable, type "yes" at the confirmation prompt to proceed. Executing the plan will take a few minutes since Terraform waits for the EC2 instance to become available.

```txt
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_instance.tf-example-ec2: Creating...
aws_instance.tf-example-ec2: Still creating... [10s elapsed]
aws_instance.tf-example-ec2: Still creating... [20s elapsed]
aws_instance.tf-example-ec2: Still creating... [30s elapsed]
aws_instance.tf-example-ec2: Still creating... [40s elapsed]
aws_instance.tf-example-ec2: Creation complete after 43s [id=i-080d16db643703468]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

- Visit the EC2 console to see the created EC2 instance.

### output command.



- Output values make information about your infrastructure available on the command line, and can expose information for other Terraform configurations to use.

- Now add the followings to the `main.tf` file.  Then run the commands `terraform apply or terraform refresh` and `terraform output`. `terraform output` command is used for reading an output from a state file. It reads an output variable from a Terraform state file and prints the value. With no additional arguments, output will display all the outputs for the (parent) root module.  If NAME is not specified, all outputs are printed.

```go
output "tf_example_public_ip" {
  value = aws_instance.tf-ec2.public_ip
}

output "tf_example_s3_meta" {
  value = aws_s3_bucket.tf-s3.region
}
```

```bash
terraform apply
terraform output
terraform output -json
terraform output tf_example_public_ip
```

#### environment variables

- Terraform searches the environment of its own process for environment variables named `TF_VAR_` followed by the name of a declared variable.

- You can also define variable with environment variables that begin with `TF_VAR_`.

```bash

terraform plan
```

#### In variable definitions (.tfvars)

- Create a file name `terraform.tfvars`. Add the followings.
  
 ```bash

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket to create"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to create the S3 bucket in"
}   ```



```bash

terraform plan

```


            
            

- Terraform loads variables in the following order:

  - Any -var and -var-file options on the command line, in the order they are provided.
  - Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
  - The terraform.tfvars.json file, if present.
  - The terraform.tfvars file, if present.
  - Environment variables

- Run terraform apply command.

```bash

terraform apply 

```


### Destroy

The `terraform destroy` command terminates resources defined in your Terraform configuration. This command is the reverse of terraform apply in that it terminates all the resources specified by the configuration. It does not destroy resources running elsewhere that are not described in the current configuration. 


```bash

terraform destroy
```
