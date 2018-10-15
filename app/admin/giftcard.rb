ActiveAdmin.register Giftcard do
  menu :priority => 2

  #permit_params :description, :amount, :country, :active
  permit_params :name, :description, :amount,:in_which_store,:category,:thumbnail,:preview_swedish,:preview_english
  #actions :all, except: [:show]

  index do
    column :name
    column :description
    column :amount
    column :in_which_store
    column :category
    column :created_at
    column :updated_at
    
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :amount
      f.input :in_which_store
      f.input :category      
      f.input :thumbnail, as: :file   
      f.input :preview_swedish, as: :file  
      f.input :preview_english, as: :file   
    end
  
    f.actions
  end

  def update
    super Giftcard:  edit_giftcard_path(resource.giftcard)
    #super location: edit_admin_giftcard (resource.giftcard)

  end


end
