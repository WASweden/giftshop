ActiveAdmin.register Card do
  permit_params :order, :text, :quantity, :receiver, :send_at

  actions :all, except: [:index, :new, :show, :destroy]

  menu false

  index do
    selectable_column
    id_column
    column :text
    column :order
    column :quantity
    column :donor do |c|
      link_to(c.donor, admin_donor_path(c))
    end
    column :send_at
    column :sent_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :order
      row :quantity
      row :receiver
      row :send_at
      row :sent_at
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Details' do
      f.input :text unless f.object.class.eql?(AnalogCard)
      # f.input :image unless f.object.class.eql?(AnalogCard)
      f.input :quantity
      f.input :receiver unless f.object.class.eql?(AnalogCard)
      f.input :send_at  unless f.object.class.eql?(AnalogCard)
    end

    f.actions do
      f.action(:submit)
      f.cancel_link admin_order_url(resource.order)
    end
  end

  controller do
    def update
      super location: admin_order_path(resource.order)
    end
  end

end
