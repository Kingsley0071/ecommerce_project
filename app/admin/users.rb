ActiveAdmin.register User do
  # Permitted parameters for creating/updating users
  permit_params :email, :username, :password, :password_confirmation, :address, :city, :postal_code, :province

  # Configure the index page (listing of users)
  index do
    selectable_column
    id_column
    column :username
    column :email
    column :address
    column :city
    column :province
    column :created_at
    actions
  end

  # Configure filters (search functionality)
  filter :username
  filter :email
  filter :city
  filter :province
  filter :created_at

  # Configure the form for creating/editing users
  form do |f|
    f.inputs do
      f.input :username
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :address
      f.input :city
      f.input :postal_code
      f.input :province, as: :select, collection: [
        ['Alberta', 'AB'],
        ['British Columbia', 'BC'],
        ['Manitoba', 'MB'],
        ['New Brunswick', 'NB'],
        ['Newfoundland and Labrador', 'NL'],
        ['Northwest Territories', 'NT'],
        ['Nova Scotia', 'NS'],
        ['Nunavut', 'NU'],
        ['Ontario', 'ON'],
        ['Prince Edward Island', 'PE'],
        ['Quebec', 'QC'],
        ['Saskatchewan', 'SK'],
        ['Yukon', 'YT']
      ], prompt: 'Select Province/Territory'
    end
    f.actions
  end

  # Configure the show page (individual user details)
  show do
    attributes_table do
      row :id
      row :username
      row :email
      row :address
      row :city
      row :postal_code
      row :province
      row :created_at
      row :updated_at
    end
  end
end