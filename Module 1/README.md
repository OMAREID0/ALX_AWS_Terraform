# Static Website Hosting on Amazon S3 with Terraform

This project provisions an **Amazon S3–based static website** using Terraform, following AWS architectural best practices for **availability, data protection, cost optimization, and disaster recovery**.

It is designed to match the requirements of the **Café Static Website Challenge Lab** and demonstrates how to implement the same solution using **Infrastructure as Code** instead of manual console work.

---

## Architecture Overview

The infrastructure includes:

- An S3 bucket for static website hosting
- Public access configuration using ACLs and bucket policy (lab-compliant)
- Object versioning to protect against accidental deletion or overwrite
- Lifecycle rules to optimize storage costs
- Optional cross-Region replication for disaster recovery

---

## Features Implemented

### 1. Static Website Hosting
- S3 bucket configured with website hosting enabled
- `index.html` used as the entry point
- Publicly accessible website endpoint

### 2. Public Access Configuration
- Public access block settings adjusted to allow public reads
- Bucket ACL set to `public-read`
- Compatible with AWS lab requirements

### 3. Data Protection
- S3 versioning enabled
- Preserves all historical versions of objects
- Prevents permanent data loss from accidental overwrites

### 4. Lifecycle Management
- Noncurrent object versions transition to **S3 Standard-IA** after 30 days
- Noncurrent object versions are permanently deleted after 365 days
- Explicit lifecycle rule filters to ensure future provider compatibility

---

<p align="center">
  <img src="images/image.png" width="600">
</p>

---
## Prerequisites

- Terraform >= 1.2
- AWS CLI configured with valid credentials
- An AWS account or lab environment with S3 and IAM permissions
- A local `index.html` file in the project directory

---

## Project Structure

```
.
├── main.tf
├── s3_bucket.tf
├── s3_policy.tf
├── s3_lifecycle.tf
├── README.md
└── index.html
```

---

## How to Deploy

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the execution plan:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. Confirm the static website URL from the S3 website endpoint.

---

## Notes and Limitations

- This configuration intentionally allows public access to meet lab requirements.
- ACL usage is included for compatibility with the challenge environment.
- In production environments, AWS recommends **bucket policies and CloudFront** instead of ACLs.
- S3 bucket names must be globally unique.

---

## Clean-Up

To remove all resources created by this project:

```bash
terraform destroy
```
---

## Outcome

This project demonstrates how a simple café website can be deployed securely and efficiently using AWS S3 and Terraform while applying real-world cloud architecture principles.
