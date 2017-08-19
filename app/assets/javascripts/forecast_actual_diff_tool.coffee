draw = (id) ->
  canvas = document.getElementById('actual-canvas')
  context = canvas.getContext('2d')
  context.clearRect(0, 0, canvas.width, canvas.height)

  data = $('#actual-canvas').data('area-rain')
  area = 0
  for y in [0...29]
    for x in [0...40]
      context.beginPath()
      context.globalAlpha = 0.5
      context.rect(x * 15, y * 15, 15, 15)
      context.fillStyle = 'rgb('+ (255 - data[area].rain) + ',' + (255 - data[area].rain) + ',255)'
      context.fill()
      area += 1

  canvas = document.getElementById('forecast-canvas')
  context = canvas.getContext('2d')
  context.clearRect(0, 0, canvas.width, canvas.height)

  data = $('#forecast-canvas').data('area-rain')
  area = 0
  for y in [0...29]
    for x in [0...40]
      context.beginPath()
      context.globalAlpha = 0.5
      context.rect(x * 15, y * 15, 15, 15)
      context.fillStyle = 'rgb('+ (255 - data[area].rain) + ',' + (255 - data[area].rain) + ',255)'
      context.fill()
      area += 1

$(window).ready(draw)
