class AddRiverLevels < ActiveRecord::Migration[5.1]
  def change
    add_column :rivers, :level_indicators, :string
  end
end
