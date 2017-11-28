class AddModelConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :model_configs do |t|
      t.integer :lstm_layers
      t.integer :dense_layers
      t.integer :epochs
      t.integer :default

      t.timestamps
    end
  end
end
