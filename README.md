
# Smart Library Management Platform

## 1. Project Overview

This project demonstrates automated AWS infrastructure provisioning and web application deployment using Terraform, Ansible, Docker, and Git.

The Smart Library Management Platform is a lightweight web application deployed on an AWS EC2 instance. Infrastructure is provisioned using Terraform, and server configuration and application deployment are automated using Ansible and Docker.

## 2. Objectives

- Provision AWS infrastructure using Terraform.
- Create a VPC, subnet, internet gateway, security group, EC2 instance, and S3 bucket.
- Install and configure Docker on the target EC2 instance.
- Automate application deployment using Ansible.
- Host and verify the web application over HTTP.
- Maintain project source code using Git and GitHub.

## 3. Technologies Used

- Amazon Web Services (AWS)
- Amazon EC2 and S3
- Terraform
- Ansible
- Docker
- Nginx
- Ubuntu Linux
- Git and GitHub

## 4. Project Structure

```text
smart-library-devops/
├── app/
│   ├── index.html
│   └── Dockerfile
├── ansible/
│   ├── deploy-library.yml
│   └── inventory.ini.example
├── terraform/
│   ├── main.tf
│   └── .terraform.lock.hcl
├── docs/
│   └── screenshots/
├── .gitignore
└── README.md
```

## 5. Infrastructure Provisioning

Terraform provisions the AWS resources required for the deployment, including:

- Virtual Private Cloud (VPC)
- Public subnet
- Internet gateway and routing
- Security group
- EC2 instance
- S3 backup bucket

The infrastructure was successfully created using Terraform.

## 6. Configuration Management and Deployment

Ansible automates the configuration of the target EC2 instance. The deployment playbook installs Docker, ensures the Docker service is running, copies the application HTML file, and starts an Nginx container.

The application container publishes port 80 internally through host port 8080.

## 7. Application Verification

The deployed application was verified in a web browser using:

http://3.106.215.171:8080

The Smart Library Management Platform loaded successfully.

## 8. Security Considerations

- Private SSH keys and Terraform state files must not be committed to GitHub.
- The actual Ansible inventory is excluded from the repository.
- Restrict SSH access to trusted IP addresses instead of allowing access from all IP addresses.
- Apply least-privilege permissions to AWS IAM roles and policies.

## 9. Conclusion

The project successfully demonstrates Infrastructure as Code with Terraform, server configuration with Ansible, and containerized web application deployment using Docker and Nginx on AWS EC2. GitHub is used to maintain the project source code and configuration files.

## 10. Future Improvements

- Implement a continuous integration and continuous deployment pipeline using GitHub Actions.
- Add application monitoring and centralized logging.
- Configure HTTPS and a domain name.

