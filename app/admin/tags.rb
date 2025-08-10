# app/admin/tags.rb
ActiveAdmin.register Tag do
  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column :products do |tag|
      tag.products.map { |p| link_to p.name, admin_product_path(p) }.join(", ").html_safe
    end
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :products_name, as: :select, collection: proc { Product.all.pluck(:name, :id) }
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :products, as: :check_boxes, collection: Product.all
    end
    f.actions
  end
end
