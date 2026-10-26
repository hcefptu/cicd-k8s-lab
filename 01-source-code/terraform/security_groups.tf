#EC2_SG
resource "aws_security_group" "hextone_ec2_sg" {
    name        = "hextone_ec2_sg"
    vpc_id      = aws_vpc.hextone_vpc.id
    description = "Allow SSH and HTTP into EC2"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH"
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = { Name = "hextone_ec2_sg" }
}