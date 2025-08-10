class ProductsController < ApplicationController
  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "Product '#{@product.name}' was successfully created!"
      redirect_to @product
    else
      flash.now[:alert] = "There was a problem creating the product."
      render :new
    end
  end

  def index
    @q = Product.ransack(params[:q])
    case params[:filter]
    when "on_sale"
      @products = @q.result.on_sale.page(params[:page])
    when "recently_updated"
      @products = @q.result.recently_updated.page(params[:page])
    else
      @products = @q.result.page(params[:page])
    end
    @breadcrumbs = [
      { name: "Home", path: root_path },
      { name: "Products", path: products_path }
    ]
  end

  def show
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      redirect_to products_path, alert: "Product not found."
    else
      session[:last_viewed_product_id] = @product.id
      @breadcrumbs = [
        { name: "Home", path: root_path },
        { name: "Products", path: products_path },
        { name: @product.name, path: product_path(@product) }
      ]
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:notice] = "Product updated successfully."
      redirect_to @product
    else
      flash.now[:alert] = "There was a problem updating the product."
      render :edit
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :image, :category_id)
  end
end
