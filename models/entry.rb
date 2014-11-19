require 'mongoid'

class Entry
  include Mongoid::Document
  include Mongoid::Timestamps

  # field :category, type: String
  # field :group, type: String
  field :title, type: String
  field :excerpt, type: String
  field :body, type: String
  
  default_scope desc(:created_at)

  # def category
  #   @category ||= Category.find_by_name(read_attribute(:category))
  # end
  # 
  # def group
  #   category.find_group(read_attribute(:group)).title
  # end
  
  # def category_title
  #   cate.title
  # end
  # 
  # def group_title
  #   cate.find_group(group).title
  # end

  # protected
  # 
  # def cate
  #   @category ||= Category.find_by_name(category)
  # end
end
