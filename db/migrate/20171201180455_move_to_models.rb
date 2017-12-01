class MoveToModels < ActiveRecord::Migration[5.1]
  def change
    rename_column :predictions, :river_id, :model_id
    remove_column :predicted_river_levels, :river_id

    Prediction.all.each do |prediction|
      model = Model.find_by(river_id: prediction.model_id)
      if model.present?
        prediction.update(model_id: model.id)
        next
      end

      model = Model.create!(river_id: prediction.model_id, model_config_id: 1, model_path: "Data/Models/river#{prediction.model_id}-1.h5")
      prediction.update(model_id: model.id)
    end
  end
end
