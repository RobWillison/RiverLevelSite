class CreateGatherers < ActiveRecord::Migration[5.1]
  def change
    create_table :gatherers do |t|
      t.string :name
      t.string :results_table
      t.datetime :last_run

      t.timestamps
    end
  end
end
