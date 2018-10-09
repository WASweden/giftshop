ActiveAdmin.register Donor do
  permit_params :first_name, :last_name, :email, :phone,
                :company, :org_number,
                :address, :post_code, :city, :country_code,
                :donor_type

  actions :all, except: [:index, :show, :destroy]

  menu false

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Type' do
      f.input :donor_type, as: :select, collection: Donor::DONOR_TYPES.keys, include_blank: false
    end

    f.inputs 'Details' do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone
    end

    f.inputs 'Company' do
      f.input :company
      f.input :org_number
    end

    f.inputs 'Address' do
      f.input :address
      f.input :post_code
      f.input :city
      f.input :country_code, as: :country_select
    end

    f.actions do
      f.action :submit
      f.cancel_link admin_order_url(resource.order)
    end
  end

  controller do
    def update
      super location: admin_order_path(resource.order)
    end
  end
end
