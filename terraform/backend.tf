# S3 backend for Terraform state management
#
# SETUP INSTRUCTIONS:
# 1. First run: terraform init
#    This will initialize Terraform locally without a remote backend
#
# 2. Run: terraform apply
#    This will create the S3 bucket, CloudFront distribution, and other resources
#
# 3. Create a separate S3 bucket for Terraform state (if not exists):
#    aws s3api create-bucket \
#      --bucket terraform-state-${ACCOUNT_ID}-${REGION} \
#      --region ap-south-1
#
# 4. Enable versioning on the state bucket:
#    aws s3api put-bucket-versioning \
#      --bucket terraform-state-${ACCOUNT_ID}-${REGION} \
#      --versioning-configuration Status=Enabled
#
# 5. Block public access to the state bucket:
#    aws s3api put-public-access-block \
#      --bucket terraform-state-${ACCOUNT_ID}-${REGION} \
#      --public-access-block-configuration \
#      "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
#
# 6. Uncomment the configuration below and update the bucket name
#
# 7. Run: terraform init -migrate-state
#    This will migrate the local state to the S3 backend
#
# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-ACCOUNT-ID-ap-south-1"
#     key            = "portfolio-site/terraform.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }
