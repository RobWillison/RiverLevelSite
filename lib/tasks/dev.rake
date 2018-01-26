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
      prediction = Prediction.joins(:model).where(live: 1, river_id: id).order(id: :desc).first
      predict_data = prediction.get_prediction_data

      $redis.set(key, predict_data.to_json)
      puts "Setting key #{key}"
    when /river-data-index/
      $redis.del(key)
    end
  end
end