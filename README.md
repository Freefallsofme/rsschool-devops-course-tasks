Infrastructure Setup

1. **VPC**

   * CIDR: `10.0.0.0/16`
2. **Subnets**

   * Public Subnets: `10.0.1.0/24`, `10.0.2.0/24`
   * Private Subnets: `10.0.3.0/24`, `10.0.4.0/24`
3. **Internet Gateway** and **Route Tables**

   * Public route table → attaches to Internet Gateway
   * Private route table → routes through NAT instance
4. **Security Groups**

   * **bastionsg**: SSH from your IP only
   * **privatesg**: SSH from Bastion only; all outbound allowed
   * **natsg**: VPC‑internal access for NAT instance
5. **Instances**

   * **Bastion Host** in a public subnet
   * **NAT Instance** in a public subnet (source\_dest\_check disabled)

## Usage

1. Initialize Terraform:

   ```bash
   terraform init
   ```

2. Preview changes:

   ```bash
   terraform plan
   ```

3. Apply configuration:

   ```bash
   terraform apply
   # Type 'yes' to confirm
   ```

4. SSH to Bastion Host:

   ```bash
   ssh -i <key.pem> ubuntu@<Bastion_Public_IP>
   ```

5. From Bastion, SSH to a private instance:

   ```bash
   ssh -i <key.pem> ubuntu@<Private_Instance_IP>
   ```

6. To destroy resources:

   ```bash
   terraform destroy
   # Type 'yes' to confirm
   ```
