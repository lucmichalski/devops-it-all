#resource "aws_eip" "haproxy" {
  #vpc = true
#
  #tags = {
    #Name = "haproxy_devopsitall_eip"
  #}
#}

resource "aws_iam_role" "haproxy_ec2_eks_readonly" {
  name = "haproxy_ec2_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com",
        "Service": "eks.amazonaws.com",
        "Service": "sts.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "haproxy_ec2_eks_readonly {
  name = "haproxy_ec2_role_policy"
  role = aws_iam_role.haproxy_ec2_eks_readonly.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "EksReadOnly",
        "Effect": "Allow",
        "Action": [
            "eks:DescribeCluster",
            "eks:ListCluster"
        ],
        "Resource": "*"
      }, 
      { 
        "Sid": "Ec2AssociateAddr",
        "Effect": "Allow",
        "Action": "ec2:AssociateAddress",
        "Resource": "*"
      },
      {
        "Sid": "AssumeSts",
        "Effect": "Allow",
        "Action": "sts:*",
        "Resource": "*"
      }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "haproxy_ec2_eks_readonly" {
  name = "haproxy_ec2_eks_readonly_iam_instance_profile"
  role = aws_iam_role.haproxy_ec2_eks_readonly.name
}

resource "aws_launch_configuration" "haproxy" {
  name_prefix                  = "haproxy_launch_configuration_devopsitall-"
  image_id                     = data.aws_ami.devops-it-all-consulNhaproxy-AMI.id
  instance_type                = var.haproxy_instance_type
  key_name                     = "devopsitall"
  security_groups              = [data.terraform_remote_state.vpc-n-eks.outputs.aws_worker_security_group]
  associate_public_ip_address  = true
  iam_instance_profile         = aws_iam_instance_profile.haproxy_ec2_eks_readonly.name 
  user_data                    = data.template_cloudinit_config.haproxy_userdata.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "haproxy" {
  name                    = "haproxy_autoscaling-devops-it-all"
  launch_configuration    = aws_launch_configuration.haproxy.name
  vpc_zone_identifier     = data.terraform_remote_state.vpc-n-eks.outputs.aws_subnet_ids_public
  min_size                = var.haproxy_scale_size
  max_size                = var.haproxy_scale_size
  desired_capacity        = var.haproxy_scale_size
  health_check_type       = "EC2"
  force_delete            = true

  tag { 
    key                 = "Name"
    value               = "haproxy_autoscaling-devops-it-all"
    propagate_at_launch = true
  }
}
