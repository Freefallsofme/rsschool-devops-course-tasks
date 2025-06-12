# rsschool-devops-course-tasks
rsschool-devops-course-tasks

Note about infrastructure.

I’ve built a fully automated AWS infrastructure pipeline using Terraform and GitHub Actions. I defined and deployed an S3 bucket to store my Terraform state, secured access with an IAM user (protected by MFA) for local work and an OIDC-backed IAM role for GitHub Actions, and configured a CI/CD workflow that automatically formats, plans, and applies my Terraform code on PRs and pushes—everything managed through AWS CLI and Terraform.
