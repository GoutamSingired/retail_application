# app/controllers/api/approval_queues_controller.rb
class Api::ApprovalQueuesController < ApplicationController
    before_action :set_approval_queue, only: [:approve, :reject]

    # GET /api/approval_queues
    def index
      approval_queue_products = ApprovalQueue.includes(:product).order(created_at: :asc).map(&:product)
      render json: approval_queue_products
    end
  
    # PUT /api/approval_queues/:id/approve
    # API to Approve a Product in Approval Queue
    def approve
        case @approval_queue.action
        when "creation_approval"
          # Logic for approving creation approval
          @approval_queue.destroy
          render json: { message: "Product #{@approval_queue.action} approved successfully" }
        when "updation_approval"
          # Logic for approving updation approval
          @approval_queue.destroy
          render json: { message: "Product #{@approval_queue.action} approved successfully" }
        when "deletion_approval"
          @approval_queue.product.destroy
          @approval_queue.destroy
          render json: { message: "Product #{@approval_queue.action} approved successfully" }
        else
          render json: { error: "Invalid action type" }, status: :unprocessable_entity
        end
      end
      

    # PUT /api/approval_queues/:id/reject
    # API to Reject a Product in Approval Queue
    def reject
        case @approval_queue.action
        when "creation_approval"
          # Logic for rejecting creation approval
          @approval_queue.destroy
          render json: { message: "Product creation rejected" }
        when "updation_approval"
          # Logic for rejecting updation approval
          @approval_queue.destroy
          render json: { message: "Product updation rejected" }
        when "deletion_approval"
          @approval_queue.destroy
          render json: { message: "Product deletion rejected" }
        else
          render json: { error: "Invalid action type" }, status: :unprocessable_entity
        end
      end
      

    private

    def set_approval_queue
        @approval_queue = ApprovalQueue.find_by(id: params[:approval_id])
      
        if @approval_queue.nil?
          render json: { error: "Approval queue with ID #{params[:approval_id]} not found" }, status: :not_found
        end
      end
      
end