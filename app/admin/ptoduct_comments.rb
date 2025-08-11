ActiveAdmin.register Comment, as: "ProductComment" do
  permit_params :content, :user_id, :product_id

  index do
    selectable_column
    id_column
    column :content
    column :user
    column :product
    actions
  end

  form do |f|
    f.inputs do
      f.input :user
      f.input :product
      f.input :content
    end
    f.actions
  end
end