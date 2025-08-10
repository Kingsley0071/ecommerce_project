require "stripe"

class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]

  def index
    @orders = current_user.orders.order(created_at: :desc)
    @breadcrumbs = [
      { name: "Home", path: root_path },
      { name: "Orders", path: orders_path }
    ]
  end

  def new
    @order = Order.new
    @breadcrumbs = [
      { name: "Home", path: root_path },
      { name: "Orders", path: orders_path },
      { name: "New Order", path: new_order_path }
    ]
  end

  def create
  @order = current_user.orders.build(order_params)
  @order.total = calculate_cart_total
  @order.status = "pending"
  if @order.save
    current_cart.each do |product_id, quantity|
      product = Product.find(product_id)
      tax_rate = 0.13 # Example: 13% tax, or fetch from your tax logic
      @order.order_items.create(
        product: product,
        quantity: quantity,
        price: product.price,
        tax_rate: tax_rate
      )
    end
    session[:cart] = {} # Clear the cart in session
    flash[:notice] = "Thank you for your order! Your order number is ##{@order.id}."
    redirect_to @order
  else
    flash.now[:alert] = "There was a problem placing your order."
    render :new
  end
end

  def show
    @order = Order.find(params[:id])
    @breadcrumbs = [
      { name: "Home", path: root_path },
      { name: "Orders", path: orders_path },
      { name: "Order ##{@order.id}", path: order_path(@order) }
    ]
  end

  # Admin can update order status
  def update
    @order = Order.find(params[:id])
    if current_user.admin? # You need an admin? method or role
      @order.update(status: params[:order][:status])
      redirect_to @order, notice: "Order status updated."
    else
      redirect_to @order, alert: "Not authorized."
    end
  end

  # Stripe Checkout integration
  def create_checkout_session
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)

    # If you have a Cart model associated with the user, use it; otherwise, use session cart
    if defined?(current_user.cart) && current_user.cart.present?
      cart = current_user.cart
      line_items = cart.cart_items.map do |item|
        {
          price_data: {
            currency: "usd",
            product_data: {
              name: item.product.name,
              images: [ item.product.image_url ].compact # optional, only if image_url exists
            },
            unit_amount: (item.product.price * 100).to_i # Stripe expects cents
          },
          quantity: item.quantity
        }
      end
    else
      line_items = current_cart.map do |product_id, quantity|
        product = Product.find(product_id)
        {
          price_data: {
            currency: "usd",
            product_data: {
              name: product.name
            },
            unit_amount: (product.price * 100).to_i
          },
          quantity: quantity
        }
      end
    end

    session = Stripe::Checkout::Session.create(
      payment_method_types: [ "card" ],
      line_items: line_items,
      mode: "payment",
      success_url: orders_url + "?success=true",
      cancel_url: cart_url
    )

    redirect_to session.url, allow_other_host: true
  rescue Stripe::StripeError => e
    flash[:alert] = e.message
    redirect_to cart_path
  end

  private

  def order_params
    params.require(:order).permit(:address, :city, :province, :postal_code)
  end

  def calculate_cart_total
    current_cart.sum do |product_id, quantity|
      product = Product.find(product_id)
      product.price * quantity
    end
  end
end
