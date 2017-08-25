class CreatePredictions < ActiveRecord::Migration[5.1]
  def change
    create_table :predictions do |t|
      t.datetime :created_date

      t.timestamps
    end
  end
end
