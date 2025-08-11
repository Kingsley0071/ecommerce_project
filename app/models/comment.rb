class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :content, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["product", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "id_value", "product_id", "updated_at", "user_id"]
  end
end