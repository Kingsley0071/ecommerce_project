# app/models/product_tag.rb
class ProductTag < ApplicationRecord
  belongs_to :product
  belongs_to :tag
  validates :product_id, uniqueness: { scope: :tag_id }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "product_id", "tag_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["product", "tag"]
  end
end