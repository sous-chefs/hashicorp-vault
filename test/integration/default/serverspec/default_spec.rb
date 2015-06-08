require 'spec_helper'

describe service('vault') do
  it { should be_running }
end
