property :destination, String,
  name_property: true

property :source, String

property :create_dest_dirs, [true,false],
  default: true

property :contents, String

property :command, String

property :command_timeout, String

property :error_on_missing_key, [true,false]

property :perms, String

property :backup, [true,false]

property :wait, String

property :left_delimiter, String

property :right_delimiter, String

property :sandbox_path, String

action :add do
  new_template = {
    'destination': new_resource.destination,
    'create_dest_dirs': new_resource.create_dest_dirs
  }

  new_template['source'] = new_resource.source unless new_resource.source.nil?
  new_template['contents'] = new_resource.contents unless new_resource.contents.nil?
  new_template['command'] = new_resource.command unless new_resource.command.nil?
  new_template['command_timeout'] = new_resource.command_timeout unless new_resource.command_timeout.nil?
  new_template['perms'] = new_resource.perms unless new_resource.perms.nil?
  new_template['error_on_missing_key'] = new_resource.error_on_missing_key unless new_resource.error_on_missing_key.nil?
  new_template['backup'] = new_resource.backup unless new_resource.backup.nil?
  new_template['wait'] = new_resource.wait unless new_resource.wait.nil?
  new_template['left_delimiter'] = new_resource.left_delimiter unless new_resource.left_delimiter.nil?
  new_template['right_delimiter'] = new_resource.right_delimiter unless new_resource.right_delimiter.nil?
  new_template['sandbox_path'] = new_resource.sandbox_path unless new_resource.sandbox_path.nil?

  VaultAgentTemplateCollection.instance.addItem(new_template)
end
