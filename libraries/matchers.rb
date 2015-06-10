if defined?(ChefSpec)
  %i{enable disable stop start restart reload}.each do |action|
    define_method(:"#{action}_vault_service") do |resource_name|
      ChefSpec::Matchers::ResourceMatcher.new(:vault_service, action, resource_name)
    end
  end

  def create_vault_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:vault_config, :create, resource_name)
  end

  def delete_vault_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:vault_config, :create, resource_name)
  end
end
