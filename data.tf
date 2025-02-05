data "aws_ami" "ami_info" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["973714476881"] # Specify the owner (e.g., Amazon AMIs)
}

# data "aws_route53_zone" "selected" {
#   name         = "hellandhaven.xyz"
#   private_zone = false
# }

data "aws_ssm_parameter" "key_pair" {
  name = "/${var.project_name}/${var.environment}/devops"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "nexus_ami_info" {

    most_recent = true
    owners = ["679593333241"]

    filter {
        name   = "name"
        values = ["SolveDevOps-Nexus-Server-Ubuntu20.04-20240511-*"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}



# data "aws_subnets" "default" {
#   filter {
#     name = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
#   filter {
#     name = "default-for-az"
#     values = ["true"]
#   }
# }
# data "aws_region" "current" {}
