class River < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name Rails.application.class.parent_name.underscore
  document_type self.name.downcase

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :river, analyzer: 'english'
      indexes :section, analyzer: 'english'
    end
  end

  def as_indexed_json(options = nil)
    self.as_json( only: [ :river, :section ] )
  end

  def name
    river + ' - ' + section
  end

  class << self
    def search(query)
      __elasticsearch__.search(
        {
          query:
          { multi_match:
            {
              query: query,
              fields: ['river', 'section'],
              fuzziness: "AUTO",
              operator:  "and",
            }
          }
        })
    end

    def index!
      self.all.each do |i|
        i.__elasticsearch__.index_document
      end
    end
  end
end
