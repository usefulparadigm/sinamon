require 'mongoid'

class Entry
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :excerpt, type: String
  field :body, type: String
  
  # validates :title, present: true
  
  default_scope desc(:created_at)
  def to_s; title end
end
