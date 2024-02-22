class ApprovalQueue < ApplicationRecord
  belongs_to :product
  enum action: { creation_approval: "creation_approval", updation_approval: "updation_approval", deletion_approval: "deletion_approval" }
end
