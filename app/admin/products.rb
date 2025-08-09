# app/admin/products.rb
ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock, :category_id, :image, tag_ids: []

  # Prevent ActiveAdmin from trying to filter on invalid associations
  remove_filter :image_attachment
  remove_filter :image_blob
  remove_filter :product_tags

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :stock
    column :category
    column :tags do |product|
      product.tags.map { |t| link_to t.name, admin_tag_path(t) }.join(", ").html_safe
    end
    column "Image" do |product|
      if product.image.attached?
        image_tag url_for(product.image.variant(:thumbnail)), size: "50x50"
      end
    end
    actions
  end

  filter :name
  filter :description
  filter :price
  filter :stock
  filter :category, as: :select, collection: proc { Category.all.pluck(:name, :id) }
  filter :tags_name_cont, label: "Tag Name"
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock
      f.input :category
      f.input :image, as: :file
      f.input :tags, as: :check_boxes, collection: Tag.all
    end
    f.actions
  end

  show do |product|
    attributes_table do
      row :name
      row :description
      row :price
      row :stock
      row :category
      row :tags do
        product.tags.map { |t| link_to t.name, admin_tag_path(t) }.join(", ").html_safe
      end
      row :created_at
      row :updated_at
      row :image do
        if product.image.attached?
          image_tag url_for(product.image.variant(:large)), size: "200x200"
        end
      end
    end
  end
end