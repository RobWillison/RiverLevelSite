class AddUserType < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean, null: false
  end
end
