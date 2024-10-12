resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "pel_igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pel_public_rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  count     = var.public_subnet_count
  subnet_id = element(aws_subnet.public_subnet[*].id, count.index)

  # Summary:
  # aws_subnet.public_subnet[*].id: Retrieves a list of subnet IDs.
  # element(): Selects a subnet ID from the list.
  # count.index: Provides the current iteration index, ensuring that each resource gets a unique subnet ID during the iteration.
  # This is a flexible and dynamic way to assign resources across multiple subnets without hardcoding specific IDs.

  # Use Case:
  # You would use this approach when you are provisioning multiple resources (like EC2 instances, security groups, etc.) and you want each of them to be associated with a different subnet. Instead of manually specifying the subnet ID for each resource, Terraform will automatically assign the correct subnet ID based on the iteration count.

  # In this example:
  # The first route table will be in the first public subnet.
  # The second route table will be in the second public subnet.
  # The third route table will be in the third public subnet.


  route_table_id = aws_route_table.public_rt.id
}