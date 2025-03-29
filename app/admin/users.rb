ActiveAdmin.register User do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  permit_params :email, :pseudo, :description

  index do
    selectable_column
    id_column
    column :email
    column :pseudo
    column :created_at
    column :sign_in_count
    column :last_sign_in_at
    actions
  end

  filter :email
  filter :pseudo
  filter :created_at
  filter :sign_in_count
  filter :last_sign_in_at

  show do
    attributes_table do
      row :id
      row :email
      row :pseudo
      row :description
      row :created_at
      row :updated_at
      row :sign_in_count
      row :last_sign_in_at
      row :last_sign_in_ip
      row :current_sign_in_ip
    end
  end
end
