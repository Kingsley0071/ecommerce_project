ActiveAdmin.register Page do
  permit_params :title, :content

  form do |f|
    f.inputs do
      f.input :title, input_html: { readonly: true }
      f.input :content
    end
    f.actions
  end
end