class AddLiveToPredicitions < ActiveRecord::Migration[5.1]
  def change
    add_column :predictions, :live, :boolean

    Prediction.all.update_all(live: 1)
  end
end
