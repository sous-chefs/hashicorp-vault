#
# Cookbook: hashicorp-vault
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
node['hashicorp-vault']['gems'].each do |name, vers|
  chef_gem name do
    version vers
    compile_time true if respond_to?(:compile_time)
  end
  require name
end
