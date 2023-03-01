class Product < ApplicationRecord
    self.table_name = "product"
    scope :searchs, -> (search) { where("LOWER(branch) LIKE ? OR LOWER(description) LIKE ?", "%#{search.downcase}%", "%#{search.downcase}%") if search.present? && search.length >= 3 }

    validates :branch, :description, presence: true
    validates :price, numericality: { greater_than_or_equal_to: 0 }
      
  end
  