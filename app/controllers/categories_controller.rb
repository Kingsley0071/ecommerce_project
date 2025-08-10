class CategoriesController < ApplicationController
  def index
    @categories = Category.all
    @breadcrumbs = [
      { name: "Home", path: root_path },
      { name: "Categories", path: categories_path }
    ]
  end

  def show
    @category = Category.find(params[:id])
    session[:last_category] = @category.id
    @products = @category.products
    @breadcrumbs = [
      { name: "Home", path: root_path },
      { name: "Categories", path: categories_path },
      { name: @category.name, path: category_path(@category) }
    ]
  end
end
