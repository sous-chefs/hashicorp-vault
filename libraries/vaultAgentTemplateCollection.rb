class VaultAgentTemplateCollection
  attr_reader :collection

  def initialize
    @collection = []
  end

  def self.instance
    @instance ||= VaultAgentTemplateCollection.new
  end

  def add_item(item)
    @collection.push(item)
  end
end
