class ModelConfig < ApplicationRecord

  has_many :models

  def average_acuracy
    models = Model.where(model_config_id: id).joins(:predictions)
  end

end
