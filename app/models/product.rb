# app/models/product.rb
class Product < ApplicationRecord
    has_one :approval_queue
    acts_as_paranoid # Enable soft delete
  
    validates :name, presence: true
    validates :price, presence: true, numericality: { less_than_or_equal_to: 10000 }
    validates :status, presence: true
  
    after_create :push_to_approval_queue_if_needed
    before_update :check_price_increase
    before_destroy :check_approval_status

    def in_approval_queue?
        ApprovalQueue.exists?(product_id: id)
    end
  
    private
  
    def push_to_approval_queue_if_needed
      if price > 5000
        ApprovalQueue.create(product: self, action: :creation_approval)
      end
    end
  
    def check_price_increase
      return unless price_changed? && price.present? && price_was.present?
  
      if (price - price_was) / price_was.to_f > 0.5
        ApprovalQueue.create(product: self, action: :updation_approval)
      end
    end
  
    def check_approval_status
      if in_approval_queue?
        errors.add(:base, "Product cannot be deleted until it's approved")
        throw(:abort)
      else
        ApprovalQueue.create(product: self, action: :deletion_approval)
      end
    end
  end
  