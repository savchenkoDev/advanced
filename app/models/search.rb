class Search < ApplicationRecord
  RESOURCES = %w[Question Answer Comment User]

  def self.execute(query, category = nil)
    if RESOURCES.include?(category)
      model = category.classify.constantize
      model.search query
    else
      ThinkingSphinx.search query
    end
  end
end
