desc "Index Rivers"
task index: [:environment] do
  River.all.index!
end

task update_cache: [:environment] do
  $redis.keys.each do |key|
    if key =~ /prediction/
      $redis.del(key)
      puts "Removed key #{key}"
      id = key[/[0-9]*$/].to_i
      prediction = Prediction.order(id: :desc).where(river_id: id).limit(1).first
      predict_data = prediction.get_prediction_data

      $redis.set(key, predict_data.to_json)
      puts "Setting key #{key}"
    end
  end
end