class Page < ApplicationRecord
  # Allow only these attributes to be searchable in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    %w[id title content created_at updated_at]
  end

  validates :title, presence: true, uniqueness: true
  validates :content, presence: true
end
