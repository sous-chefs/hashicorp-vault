RSpec.describe HCL::Checker do
  context 'valid HCL with here document' do
    hcl_string = %(
      custom_data = <<-EOF
        #!/bin/bash
        export CLOUD_ID=${var.org_id}
        export TOPOLOGY_ID=${var.topology_id}
      EOF
      provider "aws" {
        region = "${var.aws_region}"
        access_key = "${var.aws_access_key}"
        secret_key = "${var.aws_secret_key}"
      }
      resource "aws_vpc" "default" {
        cidr_block = "10.0.0.0/16"
        enable_dns_hostnames = true
        tags {
          Name = "Event Store VPC"
        }
      }
    )

    it { expect(HCL::Checker.valid?(hcl_string)).to eq(true) }
  end

  context 'valid HCL with here document without hyphen' do
    hcl_string = %(
      resource "aws_iam_policy" "policy" {
        name        = "test_policy"
        path        = "/"
        description = "My test policy"

        policy = <<EOF
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Action": [
              "ec2:Describe*"
            ],
            "Effect": "Allow",
            "Resource": "*"
          }
        ]
      }
      EOF
      }
    )

    it { expect(HCL::Checker.valid?(hcl_string)).to eq(true) }
  end
end
