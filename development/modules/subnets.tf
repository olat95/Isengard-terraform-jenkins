resource "aws_subnet" "public_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 2 + count.index)

  # Summary [cidrsubnet(base_cidr_block, new_subnet_mask_bits, subnet_number)]
  # Base CIDR block: The CIDR block of the VPC, e.g., 10.0.0.0/16.
  # Subnet mask bits: 8, meaning you’re creating /24 subnets.
  # Subnet number: 2 + count.index, dynamically selecting different subnets for each iteration based on the current index. The iteration starts from 0.
  # count.index: This is a dynamic value representing the index of the current iteration when you are creating multiple subnets. If you're using Terraform's count feature to create multiple resources, count.index changes with each iteration (starting from 0).

  # In Context:
  # If you want to create multiple subnets from a VPC CIDR block (10.0.0.0/16), this code will create /24 subnets starting from the 3rd available subnet (10.0.2.0/24), and the subnet number will increment with each iteration due to count.index.

  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true
  count                   = var.public_subnet_count

  tags = {
    Name = "pel_public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 2 + count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = false
  count                   = var.private_subnet_count

  tags = {
    Name = "pel_private_subnet"
  }
}