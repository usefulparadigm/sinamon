require 'mongoid'

class Entry
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :body, type: String
  
  validates_presence_of :title
  
  # default_scope asc(:created_at)
  def to_s; title end
end
