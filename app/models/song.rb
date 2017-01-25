require 'elasticsearch/model'

class Song < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :artist

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :lyrics, analyzer: 'english', index_options: 'offsets', type: "string"
    end
  end

end
