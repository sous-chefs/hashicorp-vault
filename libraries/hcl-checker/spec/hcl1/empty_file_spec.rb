RSpec.describe HCL::Checker do
  context 'with empty file' do
    hcl_string = ''
    it('should parse') { expect(HCL::Checker.valid?(hcl_string)).to eq(true) }
  end
end
