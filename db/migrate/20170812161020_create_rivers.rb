class CreateRivers < ActiveRecord::Migration[5.1]
  def change
    create_table :rivers do |t|

      t.timestamps
    end
  end
end
