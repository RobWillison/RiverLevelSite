desc "Index Rivers"
task index: [:environment] do
  River.all.index!
end

task update_cache: [:environment] do
  $redis.keys.each do |key|
    case key
    when /prediction/
      $redis.del(key)
      puts "Removed key #{key}"
      id = key[/[0-9]*$/].to_i
      config = ModelConfig.find_by(default: 1)
      model = Model.where(model_config_id: config.id, river_id: id).first
      prediction = Prediction.order(id: :desc).where(model_id: model.id).limit(1).first
      predict_data = prediction.get_prediction_data

      $redis.set(key, predict_data.to_json)
      puts "Setting key #{key}"
    when /river-data-index/
      $redis.del(key)
    end
  end
end