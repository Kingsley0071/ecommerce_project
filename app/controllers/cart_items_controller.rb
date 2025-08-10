class CartItemsController < ApplicationController
  def create
    product_id = params[:product_id].to_s
    cart = current_cart
    cart[product_id] ||= 0
    cart[product_id] += 1
    session[:cart] = cart
    redirect_to products_path, notice: "Product added to cart."
  end

  def update
    product_id = params[:id].to_s
    quantity = params[:quantity].to_i
    cart = current_cart
    if cart[product_id]
      cart[product_id] = quantity
      cart.delete(product_id) if quantity <= 0
      session[:cart] = cart
    end
    redirect_to cart_path, notice: "Cart updated."
  end

  def destroy
    product_id = params[:id].to_s
    cart = current_cart
    cart.delete(product_id)
    session[:cart] = cart
    redirect_to cart_path, notice: "Item removed from cart."
  end
end
