ActiveAdmin.register Example do
  menu :priority => 2

  permit_params :description, :amount, :country, :active

  actions :all, except: [:show]

  index do
    column :amount
    column :description
    column :country
    column :active
    column :created_at
    column :updated_at

    actions
  end

  form do |f|
    f.inputs do
      f.input :description
      f.input :country, as: :string
      f.input :amount
      f.input :active
    end

    f.actions
  end
end
