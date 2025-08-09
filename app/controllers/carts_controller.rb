# app/controllers/carts_controller.rb
require 'stripe'

class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:create_checkout_session]

  def show
    @cart_items = current_cart.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      { product: product, quantity: quantity } if product
    end.compact
  end

  def create_checkout_session
    return redirect_to cart_path, alert: "Your cart is empty." if current_cart.empty?

    line_items = current_cart.map do |product_id, quantity|
      product = Product.find(product_id)
      {
        price_data: {
          currency: 'usd',
          product_data: {
            name: product.name
          },
          unit_amount: (product.price * 100).to_i # Stripe expects cents
        },
        quantity: quantity
      }
    end

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: line_items,
      mode: 'payment',
      success_url: cart_url + "?success=true",
      cancel_url: cart_url + "?canceled=true",
      customer_email: current_user.email
    )

    redirect_to session.url, allow_other_host: true
  rescue Stripe::StripeError => e
    flash[:alert] = "Stripe error: #{e.message}"
    redirect_to cart_path
  end

  private

  def current_cart
    @current_cart ||= (session[:cart] || {})
  end
end# app/controllers/carts_controller.rb
require 'stripe'

class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:create_checkout_session]

  def show
    @cart_items = current_cart.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      { product: product, quantity: quantity } if product
    end.compact
    @cart_total = @cart_items.sum { |item| item[:product].price * item[:quantity] }
    if params[:success]
      flash[:notice] = "Payment successful! Your order is being processed."
      session[:cart] = {} # Clear the cart
      @cart_items = []
      @cart_total = 0
    elsif params[:canceled]
      flash[:alert] = "Payment was canceled."
    end
  end

  def create_checkout_session
    if current_cart.empty?
      flash[:alert] = "Your cart is empty."
      return respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash") }
        format.html { redirect_to cart_path }
      end
    end

    line_items = current_cart.map do |product_id, quantity|
      product = Product.find(product_id)
      {
        price_data: {
          currency: 'usd',
          product_data: {
            name: product.name
          },
          unit_amount: (product.price * 100).to_i # Stripe expects cents
        },
        quantity: quantity
      }
    end

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: line_items,
      mode: 'payment',
      success_url: cart_url + "?success=true",
      cancel_url: cart_url + "?canceled=true",
      customer_email: current_user.email
    )

    redirect_to session.url, allow_other_host: true, status: :see_other
  rescue Stripe::StripeError => e
    flash[:alert] = "Stripe error: #{e.message}"
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash") }
      format.html { redirect_to cart_path }
    end
  end

  private

  def current_cart
    @current_cart ||= (session[:cart] || {})
  end
end