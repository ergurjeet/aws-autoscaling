# AWS Autoscaling
A basic example to provision a resilient application using auto scaling group.

## Config
### Directory structure
```
modules/
  app/
  vpc/
stage/
  terraform.tfvars
  ...
<prod>/
  <clone stage directory>
```
You can create a new directory for your other environments to keep the terraform.tfvars, user_data.sh, tfstate, etc., separate.


## Setup

```
git clone git@github.com:ergurjeet/aws-autoscaling.git
cd aws-autoscaling/stage
terraform init
terraform plan
terraform apply
```

## Exceptions
- `"Unable to find remote state"`: Create an empty state file on S3
```
{
  "version": 4,
  "outputs": {},
  "resources": []
}
```
and then run `terraform init`

## Simulate cpu load
SSH into a node
```
sudo su
amazon-linux-extras install epel -y
yum install stress -y
stress --cpu  2 --timeout 300
```
