RSpec.describe HCL::Checker do
  context 'with spurious commas' do
    hcl_string = %(
      resource "aws_security_group" "allow_tls" {
        name        = "allow_tls"
        description = "Allow TLS inbound traffic"
        vpc_id      = "${aws_vpc.main.id}",

        ingress {
          from_port   = 443
          to_port     = 443
          protocol    = "-1"
          cidr_blocks = ["192.168.0.1"],
        },
      }
    )
    it('should parse') { expect(HCL::Checker.valid?(hcl_string)).to eq(true) }
  end
end
