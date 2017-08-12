class AddRiverColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :rivers, :name, :string
    add_column :rivers, :lat, :double
    add_column :rivers, :long, :double
  end
end
