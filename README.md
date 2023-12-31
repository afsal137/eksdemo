# eksdemo
This is a project to deploy a highly available sample application stack in AWS. EKS Fargate is used along with Multi AZ RDS using Terraform.

# Architecture Diagram
![eksdemo_architecture](https://github.com/afsal137/eksdemo/assets/9499064/4a5c9092-5ccd-41a7-bdf0-4082497e41c4)

​
# Components
​
<ins>**EKS Fargate**</ins>: EKS Fargate cluster is used to deploy the frontend and backend. Fargate is used so that EKS infrastructure will be serverless, i.e, nodes will be managed by AWS and there will not be much security maintenance overhead from the operational perspective.

<ins>**RDS PostgreSQL**</ins>:  A multi AZ PostgreSQL RDS is used as DB. Mutli AZ will ensure HA for the DB.

<ins>**Secrets Manager**</ins>: AWS Secrets Manger will be used to store the DB password. The value will be then later passed to k8s secrets.

<ins>**VPC**</ins>: A VPC with 4 sets of subnets, public subnets for ALB and NAT, private subnets for EKS worker nodes, intra subnets for EKS control plane and DB subnets for database. An Internet Gateway is also attached.

<ins>**ECR**</ins>: ECR repositories will be created for storing container images. The EKS cluster will fetch the images from ECR.

<ins>**IAM**</ins>: IAM will be used to creating the necessary roles and policies.

<ins>**S3 with DynamoDB**</ins>: S3 along with DynamoDB will be used to storing the Terraform state and state locking mechanism.
