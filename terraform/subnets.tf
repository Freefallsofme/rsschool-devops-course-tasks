resource "aws_subnet" "public" {
  count                   = length(var.pubsub)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pubsub[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "PubSub-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.privsub)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.privsub[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "PrivSub-${count.index + 1}"
  }
}
