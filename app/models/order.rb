class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  def self.ransackable_attributes(auth_object = nil)
    %w[address city created_at id postal_code province status total updated_at user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user order_items products]
  end

  validates :address, presence: true
  validates :city, presence: true
  validates :province, presence: true
  validates :postal_code, presence: true
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true
end
