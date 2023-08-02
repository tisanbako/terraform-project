output "vpc_id" {
    value = aws_vpc.my_vpc.id
}

output "pub1_subnet" {
    value = aws_subnet.public1_subnets[*].id
}

output "pub2_subnet" {
    value = aws_subnet.public2_subnets[*].id
}

output "private1_subnet" {
    value = aws_subnet.private1_subnets.id[*]
}

output "private2_subnet" {
    value = aws_subnet.private2_subnets.id[*]
}

