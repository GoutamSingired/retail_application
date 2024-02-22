class AddActionToApprovalQueue < ActiveRecord::Migration[7.0]
  def change
    add_column :approval_queues, :action, :string
  end
end
