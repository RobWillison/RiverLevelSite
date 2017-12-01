class AddModels < ActiveRecord::Migration[5.1]
  def change
    create_table :models do |t|
      t.integer :river_id
      t.integer :model_config_id
      t.string :model_path

      t.timestamps
    end
  end
end
