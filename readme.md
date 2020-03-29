# app to get linecount of a github repo

## Set up infrastructure

### Prerequisites

+ AWS credentials are stored in `~/.aws/credentials`
+ Terraform cli is installed 

### Set up infrastructure

The infrastructure is defined in `/infra/infra.tf`, it sets up the following:

+ S3 bucket
+ IAM role
+ bucket
+ key pair (using public key from ODM's MBP id_rsa.pub)
+ security group
+ EC2 instance

Output is the public IP of the instance.

To stand up the infrastructure:
```bash
cd infra
~/terraform plan
~/terraform apply

# get ip output
~/terraform output -json instance_ips | jq '.[0][0]'

# when done, destroy
~/terraform destroy
```

## Provision the server

### Prerequisistes

+ private key (id_rsa) is present on computer in `~\.ssh`
+ `ansible` and `ansible-playbook` are installed

### Provisioning

The server provisioning is defined in `/ansible/provision.yml`.

To run provisioning, use the following command:
```bash
ansible-playbook --vault-password-file .secret -i xxx.xxx.xxx.xxx, ansible/provision.yml
```
Note: use the IP that was the output of  `~/terraform apply`.