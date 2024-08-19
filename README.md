
# Two-Tier web application automation with Terraform, Ansible and GitHub Actions

This project demonstrates the automation of deploying a secure and scalable web application infrastructure using Terraform, Ansible, and GitHub Actions. The focus is on showcasing advanced infrastructure as code practices with Terraform, including modularization, distributed state management, and the utilization of functions, conditions, and loops.

## Prerequisites

To successfully complete this project, the following prerequisites are required:

1. AWS Account

2. Terraform: Installation of Terraform on your local machine.

3. Basic Knowledge of AWS Services:
    VPC (Virtual Private Cloud): Understanding of VPCs, subnets, route tables, and security groups.
    EC2 (Elastic Compute Cloud): Familiarity with launching and managing EC2 instances.
    VPC Peering: Knowledge of VPC peering for connecting VPCs.
    Elastic Load Balancer: Basic understanding of load balancing concepts.

4. Terraform Skills: 
    Modular Configuration, State Management, Functions, Conditions, and Loops, variable and output Management

5. Ansible:
    dynamic inventory, ansible playbook to deploy website on the webservers remotely

6. AWS S3 Bucket: 
    You should have S3 bucket that stores Terraform state.\
    For creating S3 bucket: https://docs.aws.amazon.com/AmazonS3/latest/userguide/creating-bucket.html \
    Create two S3 buckets with unique names. The buckets will store Terraform state. The names of the buckets should start with the {env}-<unique bucket name>.

7. SSH Keys:
    SSH key should be pre-created and updated in the code under keyname or prefix value. 


## File Structure 

    Final_Project/
    ├── aws_network
    ├── ansible
    ├── prod
    ├── .git
    ├── .github




## Deployment Steps

1. Update the config.tf in prod subfolders to reflect the bucket names.
2. Update the desired input varibles in prod. 
\
To deploy this project run in sequence:

          
    1. Go to Settings (click your profile picture in the top-right corner and select Settings).
    2. Navigate to Developer settings > Personal access tokens.
    3. Click Generate new token.
    4. Configure Token Scopes:
        - Give your token a name (e.g., "Cloud9 Access").   
        - Select the scopes or permissions you need
        - Click Generate token.
        - Copy the Token.
    5. Configure Git to Use the Personal Access Token:
        - git clone https://<YOUR_GITHUB_USERNAME>:<YOUR_PERSONAL_ACCESS_TOKEN>@github.com/username/repository.git
        - git remote set-url origin https://<YOUR_GITHUB_USERNAME>:<YOUR_PERSONAL_ACCESS_TOKEN>@github.com/username/repository.git
    6. Push Changes to GitHub:
        - git add .
        - git commit -m "Your commit message"
        - git push origin main
    7. Pull Changes from GitHub:
        - git pull origin main
    8. The workflow file is already uploaded in github in .github folder.
    9. Push the code to github and it will auto trigger the pipeline created using github actions.


## Webserver Deployment Steps

1. Install ansible using: pip install ansible.
2. The inventory used will be dynamic using aws_ec2 plugin.
\
To deploy the Webserver follow the steps:
          
    1. The files should be uploaded in the Cloud9 environment.
    2. Navigate to ansible folder in Final_project directory.
    3. Run the below commands:
        - ansible-inventory -i aws_ec2.yaml --list
        - ansible-inventory -i aws_ec2.yaml --graph
        -  ansible-playbook -i aws_ec2.yaml website.yaml --private-key=/home/ec2-user/.ssh/prod

By following the above your webserver will be deployed on the VMs and it will be load balanced.


## Destroying the Deployed Resources

1. Go to Cloud9 IDE and navigate to Final_project.
2. Navigate to webservers folder and run the below command:
    - terraform init
    - terraform destroy -auto-approve
3. Navigate to network folder and run the below command:
    - terraform init
    - terraform destroy -auto-approve

## Conclusion

This project demonstrates the application of Terraform, Ansible, and GitHub Actions to deploy a secure and scalable cloud infrastructure in AWS. The setup includes creating one VPC for production environments, and deploying EC2 instances with specific security rules. The use of Terraform highlights modular infrastructure as code practices with environment-specific configurations and optional load balancing for enhanced reliability.

Ansible is employed to automate the configuration and management of the deployed EC2 instances, ensuring consistent and repeatable setups. GitHub Actions are integrated to automate the CI/CD pipeline, including Terraform plan and apply steps. This integration demonstrates proficiency in automating infrastructure deployment and configuration while emphasizing secure networking practices and efficient resource management in cloud environments.

#review
