class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :image do |attachable|
    attachable.variant :thumbnail, resize_to_limit: [ 300, 200 ]
    attachable.variant :large, resize_to_limit: [ 600, 600 ]
  end
  has_many :product_tags, dependent: :destroy
  has_many :tags, through: :product_tags
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :comments, dependent: :destroy # Added association

  paginates_per 9

  scope :on_sale, -> { where("price < ?", 50) }
  scope :recently_updated, -> { order(updated_at: :desc).limit(12) }

  def self.ransackable_attributes(auth_object = nil)
    %w[id name description price stock created_at updated_at category_id tags_name_cont]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category order_items orders tags comments] # Added comments
  end

  ransacker :tags_name_cont, formatter: proc { |v|
    Product.joins(:tags).where("tags.name ILIKE ?", "%#{v}%").pluck(:id)
  } do |parent|
    parent.table[:id]
  end

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true
end