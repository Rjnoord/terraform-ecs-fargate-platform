<img width="1470" height="956" alt="Screenshot 2026-06-22 at 2 53 28 PM" src="https://github.com/user-attachments/assets/6c045e2d-2eac-4cf7-a31f-6dfda6dc914b" />
<img width="1470" height="956" alt="Screenshot 2026-06-22 at 2 53 49 PM" src="https://github.com/user-attachments/assets/19a7c862-5c61-48c3-9d11-83d2a4c2cf84" />
# AWS ECS Fargate Platform with Terraform

## Overview

This project demonstrates the deployment of a containerized Flask web application on AWS using Amazon ECS Fargate, Application Load Balancer (ALB), Amazon ECR, CloudWatch, IAM, and custom VPC networking. All infrastructure is provisioned using Terraform and managed through Infrastructure as Code (IaC) practices.

The goal of this project is to showcase cloud engineering, containerization, networking, and infrastructure automation skills commonly required in modern DevOps and Cloud Engineering roles.

---

## Architecture

```text
                    Internet
                        │
                        ▼
           ┌────────────────────────┐
           │ Application Load       │
           │ Balancer (ALB)         │
           └──────────┬─────────────┘
                      │
                      ▼
        ┌──────────────────────────────┐
        │ ECS Fargate Service          │
        │                              │
        │ Containerized Flask App      │
        └──────────┬───────────────────┘
                   │
                   ▼
         Amazon ECR Container Images

                   ▲
                   │
              Docker Build

                   ▲
                   │
               Developer
```

---

## Technologies Used

### Cloud Services

* AWS ECS Fargate
* Amazon Elastic Container Registry (ECR)
* Application Load Balancer (ALB)
* AWS Identity and Access Management (IAM)
* Amazon CloudWatch
* Amazon S3
* Amazon VPC
* Internet Gateway
* Route Tables
* Security Groups

### DevOps & Automation

* Terraform
* Docker
* Git
* GitHub

### Application

* Python
* Flask

---

## Project Objectives

* Deploy a containerized application without managing servers
* Implement Infrastructure as Code using Terraform
* Configure secure networking using a custom VPC
* Store container images in Amazon ECR
* Deploy containers using ECS Fargate
* Route traffic through an Application Load Balancer
* Centralize logs with CloudWatch
* Utilize IAM roles for secure service permissions
* Demonstrate real-world cloud deployment practices

---

## Infrastructure Components

### Networking Layer

#### VPC

A custom Virtual Private Cloud was created to isolate application resources.

Features:

* Custom CIDR block
* Internet connectivity
* Route table configuration
* Public subnet architecture

#### Public Subnets

Two public subnets were deployed across separate Availability Zones to support high availability.

Benefits:

* Fault tolerance
* Multi-AZ deployment
* Load balancer integration

#### Internet Gateway

Configured to provide outbound internet access for:

* ECS Tasks
* Container image pulls
* External connectivity

#### Route Tables

Custom route tables were configured to direct internet-bound traffic through the Internet Gateway.

---

### Security Layer

#### ECS Security Group

Allows:

* Application traffic on port 5000
* Communication from the Application Load Balancer

Restricts:

* Unnecessary inbound traffic

#### ALB Security Group

Allows:

* HTTP traffic on port 80 from the internet

Provides:

* Controlled entry point into the environment

---

### Container Platform

#### Docker

The Flask application was containerized using Docker.

Benefits:

* Portability
* Consistent deployments
* Simplified application packaging

#### Amazon ECR

Used as the private container registry.

Features:

* Image versioning
* Vulnerability scanning
* Secure image storage

---

### Compute Layer

#### Amazon ECS

An ECS Cluster was created to manage containerized workloads.

#### ECS Fargate

Fargate was selected to provide:

* Serverless container hosting
* No EC2 management
* Simplified scaling
* Reduced operational overhead

---

### Load Balancing

#### Application Load Balancer

Configured to:

* Accept HTTP traffic on port 80
* Route requests to ECS Tasks
* Perform health checks
* Improve availability

#### Target Group

Configured for:

* IP-based targets
* Port 5000 application traffic
* Health monitoring

---

### Monitoring

#### Amazon CloudWatch

Configured for:

* ECS task logs
* Container monitoring
* Operational visibility

---

### Identity and Access Management

#### ECS Task Execution Role

Used to grant ECS permissions for:

* Pulling images from ECR
* Writing logs to CloudWatch
* Accessing AWS services securely

---

## Terraform Structure

```text
terraform/
│
├── provider.tf
├── backend.tf
├── main.tf
├── securitygroups.tf
├── ecs.tf
├── alb.tf
├── iam.tf
├── cloudwatch.tf
├── variables.tf
├── outputs.tf
```

---

## Application Structure

```text
app/
│
├── app.py
├── requirements.txt
└── Dockerfile
```

---

## Deployment Workflow

### 1. Build Docker Image

```bash
docker buildx build --platform linux/amd64 -t ecs-fargate-app:latest --load .
```

### 2. Authenticate to ECR

```bash
aws ecr get-login-password --region us-east-1 \
| docker login --username AWS \
--password-stdin ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com
```

### 3. Tag Image

```bash
docker tag ecs-fargate-app:latest \
ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/ecs-fargate-devops-app:latest
```

### 4. Push Image

```bash
docker push ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/ecs-fargate-devops-app:latest
```

### 5. Deploy Infrastructure

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

---

## Challenges Encountered

### Container Architecture Mismatch

Issue:

```text
image manifest does not contain descriptor matching platform linux/amd64
```

Resolution:

Built and pushed an amd64-compatible image using:

```bash
docker buildx build --platform linux/amd64
```

### ECS Task Deployment Failures

Issue:

Tasks remained in a pending or stopped state.

Resolution:

* Verified ECR image availability
* Validated IAM execution role permissions
* Confirmed subnet configuration
* Corrected security group references
* Reviewed ECS task logs and events
* Forced new deployments after image updates

### Terraform Configuration Errors

Issues encountered:

* Missing separators in task definitions
* Incorrect subnet references
* Security group ID references
* IAM policy formatting issues
* Resource dependency troubleshooting

Resolution:

* Terraform validation
* Incremental testing
* AWS console verification
* CloudWatch log analysis

---

## Skills Demonstrated

### Cloud Engineering

* AWS ECS
* AWS Fargate
* Amazon ECR
* Application Load Balancer
* CloudWatch
* IAM
* VPC Design

### DevOps

* Docker
* Terraform
* Infrastructure as Code
* Container Lifecycle Management

### Networking

* VPC Configuration
* Security Groups
* Subnets
* Route Tables
* Internet Gateway
* Load Balancing

### Troubleshooting

* Container deployment failures
* Architecture compatibility issues
* Infrastructure debugging
* AWS service integration
* Network connectivity troubleshooting

---

## Future Enhancements

### CI/CD Pipeline

Planned integration:

* GitHub
* Jenkins
* Docker
* Amazon ECR
* ECS Deployment Automation

Workflow:

```text
GitHub
   ↓
Jenkins
   ↓
Docker Build
   ↓
Amazon ECR
   ↓
Amazon ECS
```

### Infrastructure Improvements

Planned additions:

* HTTPS with ACM Certificates
* Route 53 DNS Integration
* ECS Auto Scaling
* CloudWatch Dashboards
* SNS Notifications
* AWS WAF Protection
* Blue/Green Deployments
* Multi-Environment Support (Dev/Test/Prod)

---

## Learning Outcomes

Through this project I gained hands-on experience with:

* Containerizing applications with Docker
* Deploying workloads using ECS Fargate
* Building AWS infrastructure with Terraform
* Implementing secure cloud networking
* Managing container registries
* Configuring load balancing
* Monitoring workloads with CloudWatch
* Troubleshooting production-style deployment issues
* Working with Infrastructure as Code principles
* Managing remote Terraform state using Amazon S3

---

## Resume Highlights

* Designed and deployed a containerized Flask application on AWS ECS Fargate using Terraform Infrastructure as Code.
* Configured custom VPC networking, Application Load Balancer, IAM roles, CloudWatch logging, Amazon ECR image registry, and remote Terraform state management.
* Implemented secure networking through Security Groups, Route Tables, Public Subnets, and Internet Gateway configurations.
* Troubleshot ECS deployment issues including container architecture compatibility (ARM64 vs AMD64), networking configurations, and IAM permissions.
* Built a production-style cloud architecture leveraging AWS managed services and Infrastructure as Code best practices.

---

## Author

Cloud Engineering Portfolio Project

Built to demonstrate practical experience with:

* AWS ECS Fargate
* Amazon ECR
* Terraform
* Docker
* CloudWatch
* IAM
* Application Load Balancer
* Infrastructure as Code
* Cloud Engineering Principles

## Screenshots 

<img width="1470" height="956" alt="Screenshot 2026-06-22 at 2 31 01 PM" src="https://github.com/user-attachments/assets/30679778-2d89-42f3-bdaf-3347b8743376" />
<img width="1470" height="956" alt="Screenshot 2026-06-22 at 2 24 49 PM" src="https://github.com/user-attachments/assets/fd0a01ce-1cbb-4e35-b28d-4a8eab698a9f" />
<img width="1470" height="956" alt="Screenshot 2026-06-22 at 1 56 59 PM" src="https://github.com/user-attachments/assets/e2df00d5-1966-4da7-89ef-2cdc246bc8bb" />
<img width="1470" height="956" alt="Screenshot 2026-06-22 at 1 56 07 PM" src="https://github.com/user-attachments/assets/1049e3c3-9800-4638-83bc-62c4d387b8d4" />
<img width="1470" height="956" alt="Screenshot 2026-06-22 at 2 31 10 PM" src="https://github.com/user-attachments/assets/92174de8-91c8-4156-85d1-43644cb97a2d" />
