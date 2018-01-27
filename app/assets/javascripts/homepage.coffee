# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(window).on('loaded', () ->
  $('.overlay').fadeOut('slow') if window.timelineLoaded && window.markersLoaded)

sliderSettings = () ->
  current = new Date()
  current.setMinutes(0)
  ticks_labels = []
  ticks = []

  for i in [0..142]
    day = current.toString().split(' ')[0]
    current.setTime(current.getTime() + (1*60*60*1000))
    console.log(current.getHours())
    if ticks_labels[ticks_labels.length-1] != day
      ticks_labels.push(day)
      ticks.push(i)

  [ticks_labels, ticks]

stepToTime = (value) ->
  current = new Date()
  current.setMinutes(0)
  current.setTime(current.getTime() + (value*60*60*1000))
  day = current.toString().split(' ')[0]
  day + ' - ' + String(current.getHours()) + ':00'

initTimeslider = (predictedColours) ->
  window.predictedColours = predictedColours
  settings = sliderSettings()
  $("#timeline").slider({
    formatter: (value) -> stepToTime(value)
    ticks: settings[1],
    ticks_snap_bounds: 0,
    value: 0
  })

  $('#timeline').change(() ->
    current = new moment()
    current.minutes(0)
    current.seconds(0)
    current.millisecond(0)
    hour = $('#timeline').val()
    current.add(hour, 'hours');
    changeTime(current)
  )
  $('#timeline').trigger('change')

  window.timelineLoaded = true
  $(window).trigger('loaded')

changeTime = (time) ->
  updateOverlay(time)
  time.add(1, 'seconds')
  $.each(window.markers, (k, marker) ->
    data = window.predictedColours[marker.id]
    newColor = undefined

    for v in data
      newColor = v[1] if new Date(v[0]) < time

    icon = marker.icon
    icon.strokeColor = newColor
    marker.setIcon(icon)
  )


root = exports ? this

root.initMap = () ->
  style = [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#ebe3cd"
        }
      ]
    },
    {
      "elementType": "labels",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#523735"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#f5f1e6"
        }
      ]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#c9b2a6"
        }
      ]
    },
    {
      "featureType": "administrative.land_parcel",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#dcd2be"
        }
      ]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#ae9e90"
        }
      ]
    },
    {
      "featureType": "administrative.neighborhood",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "landscape.natural",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#dfd2ae"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#dfd2ae"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#93817c"
        }
      ]
    },
    {
      "featureType": "poi.business",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#a5b076"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#447530"
        }
      ]
    },
    {
      "featureType": "road",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#f5f1e6"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "road.arterial",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#fdfcf8"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#f8c967"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#e9bc62"
        }
      ]
    },
    {
      "featureType": "road.highway.controlled_access",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#e98d58"
        }
      ]
    },
    {
      "featureType": "road.highway.controlled_access",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#db8555"
        }
      ]
    },
    {
      "featureType": "road.local",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#806b63"
        }
      ]
    },
    {
      "featureType": "transit",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "transit.line",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#dfd2ae"
        }
      ]
    },
    {
      "featureType": "transit.line",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#8f7d77"
        }
      ]
    },
    {
      "featureType": "transit.line",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#ebe3cd"
        }
      ]
    },
    {
      "featureType": "transit.station",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#dfd2ae"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#b9d3c2"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#92998d"
        }
      ]
    }
    ]

  window.map = new google.maps.Map(
    document.getElementById('map'),
    {center: {lat: 54.559322, lng: -4.174804},
    zoom: 6,
    disableDefaultUI: true}
  )

  map.set('styles', style)
  $.getJSON(
    url: 'api/rivers',
    addMarkers
  )

addMarkers = (data) ->
  $.getJSON(
    url: 'api/predictions',
    initTimeslider
  )

  window.markers = []
  $.each( data, (key, val) ->
    location = new google.maps.LatLng(val.lat, val.long)
    marker = new google.maps.Marker({
      position: location,
      url: '/rivers/' + val.id
      icon: {
        path: google.maps.SymbolPath.CIRCLE,
        strokeColor: val.color,
        strokeWeight: 4,
        scale: 2
      }
      id: val.id
      map: window.map,
    })
    google.maps.event.addListener(marker, 'click', () ->
      window.location.href = this.url
    )
    window.markers.push(marker)
  )
  window.markersLoaded = true
  $(window).trigger('loaded')

hideOverlay = () ->
window.current_overlay = {}
window.overlay = {}
updateOverlay = (time) ->
  console.log(time)
  timestamp = time.unix()
  showOverlay(timestamp)

showOverlay = (timestamp) ->
  if window.overlay[timestamp] == undefined
    buildOverlay(timestamp.toString())

  for overlay in window.current_overlay
    if overlay.div_ != null
      overlay.div_.style.visibility = 'hidden';

  window.current_overlay = window.overlay[timestamp]

  for overlay in window.overlay[timestamp]
    if overlay.div_ != null
      overlay.div_.style.visibility = 'visible';

buildOverlay = (timestamp) ->
  data = [[52.497772, -5.576685, 55.797614, 0.033960, 'https://maps8.darksky.net/'+timestamp+'/precipitation_intensity_dbz/6/31/20.png'],
  [52.497772, -11.2, 55.797614, -5.576685, 'https://maps8.darksky.net/'+timestamp+'/precipitation_intensity_dbz/6/30/20.png'],
  [55.797614, -5.576685, 58.797614, 0.033960, 'https://maps8.darksky.net/'+timestamp+'/precipitation_intensity_dbz/6/31/19.png'],
  [55.797614, -11.2, 58.797614, -5.576685, 'https://maps8.darksky.net/'+timestamp+'/precipitation_intensity_dbz/6/30/19.png'],
  [55.797614, -16.5, 58.797614, -11.2, 'https://maps8.darksky.net/'+timestamp+'/precipitation_intensity_dbz/6/29/19.png'],
  [52.497772, -16.5, 55.797614, -11.2, 'https://maps8.darksky.net/'+timestamp+'/precipitation_intensity_dbz/6/29/20.png'],
  [52.497772, 0.033960, 55.797614, 5.5, 'https://maps8.darksky.net/'+timestamp+'/precipitation_intensity_dbz/6/32/20.png'],
  [55.797614, 0.033960, 58.797614, 5.5, 'https://maps8.darksky.net/'+timestamp+'/precipitation_intensity_dbz/6/32/19.png'],
  [49, 0.033960, 52.497772, 5.5, 'https://maps8.darksky.net/'+timestamp+'/precipitation_intensity_dbz/6/32/21.png'],
  [49, -5.576685, 52.497772, 0.033960, 'https://maps8.darksky.net/'+timestamp+'/precipitation_intensity_dbz/6/31/21.png'],
  [49, -11.2, 52.497772, -5.576685, 'https://maps8.darksky.net/'+timestamp+'/precipitation_intensity_dbz/6/30/21.png'],
  [49, -16.5, 52.497772, -11.2, 'https://maps8.darksky.net/'+timestamp+'/precipitation_intensity_dbz/6/29/21.png']]

  window.overlay[timestamp] = initOverlay(data)