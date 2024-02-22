# app/controllers/api/products_controller.rb
class Api::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /api/products
  # API to List Active Products
  def index
    @products = Product.where(status: 'active').order(created_at: :desc)
    render json: @products
  end

  # GET /api/products/search
  # API to Search Products
  def search
    @products = Product.where(nil)
    @products = @products.where("name LIKE ?", "%#{params[:productName]}%") if params[:productName].present?
    @products = @products.where("price >= ?", params[:minPrice]) if params[:minPrice].present?
    @products = @products.where("price <= ?", params[:maxPrice]) if params[:maxPrice].present?
    @products = @products.where("created_at >= ?", params[:minPostedDate]) if params[:minPostedDate].present?
    @products = @products.where("created_at <= ?", params[:maxPostedDate]) if params[:maxPostedDate].present?
    render json: @products
  end

  # POST /api/products
  # API to Create a Product
  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PUT /api/products/:id
  # API to Update a Product
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/products/:id
  # API to Delete a Product
  def destroy
    if @product.in_approval_queue?
      render json: { message: "Product is already in ApprovalQueue for deletion" }
    else
      ApprovalQueue.create(product: @product, action: :deletion_approval)
      render json: { message: "Product is sent to approval for deletion" }
    end
  end

  # GET /api/products/approval-queue
  # API to Get Products in Approval Queue
  def approval_queue
    @approval_queue_products = ApprovalQueue.includes(:product).order(created_at: :asc).map do |approval_queue|
      {
        product: approval_queue.product,
        approval_queue_id: approval_queue.id,
        approval_action: approval_queue.action
      }
    end
  
    render json: @approval_queue_products
  end
  


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def product_params
    params.require(:product).permit(:name, :price, :status)
  end
end
