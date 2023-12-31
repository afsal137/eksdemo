# eksdemo

# Summary
This is a project to deploy a highly available sample application stack in AWS. EKS Fargate is used along with Multi AZ RDS using Terraform.

# Architecture Diagram
![eksdemo_architecture](https://github.com/afsal137/eksdemo/assets/9499064/4a5c9092-5ccd-41a7-bdf0-4082497e41c4)

# Architecture Diagram
# Summary
​
This is a project to deploy a highly available sample application stack in AWS. EKS Fargate is used along with Multi AZ RDS using Terraform.
​
# Architecture Diagram
​
# Components
​
**EKS Fargate**: EKS Fargate cluster is used to deploy the frontend and backend. Fargate is used so that EKS infrastructure will be serverless, i.e, nodes will be managed by AWS and there will not be much security maintenance overhead from the operational perspective.

**RDS PostgreSQL**:  A multi AZ PostgreSQL RDS is used as DB. Mutli AZ will ensure HA for the DB.

**Secrets Manager**: AWS Secrets Manger will be used to store the DB password. The value will be then later passed to k8s secrets.

**VPC**: A VPC with 4 sets of subnets, public subnets for ALB and NAT, private subnets for EKS worker nodes, intra subnets for EKS control plane and DB subnets for database. An Internet Gateway is also attached.

**ECR**: ECR repositories will be created for storing container images. The EKS cluster will fetch the images from ECR.

**IAM**: IAM will be used to creating the necessary roles and policies.

**S3 with DynamoDB**: S3 along with DynamoDB will be used to storing the Terraform state and state locking mechanism.
