class VaultAgentTemplateCollection
  def initialize
    @collection = []
  end

  def self.instance
    @instance ||= VaultAgentTemplateCollection.new
  end

  def getCollection
    @collection
  end

  def addItem(item)
    @collection.push(item)
  end
end
