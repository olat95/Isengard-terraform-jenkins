resource "aws_eip" "eip_NGw" {
  domain = true

  tags = {
    Name = "pel_eip_NGw"
  }
}

resource "aws_nat_gateway" "pel_ngw" {
  allocation_id = aws_eip.eip_NGw.id
  subnet_id     = element(aws_subnet.public_subnet[*].id, 0)

  tags = {
    Name = "pel_ngw"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.pel_ngw.id
  }


  tags = {
    Name = "pel_private_rt"
  }
}