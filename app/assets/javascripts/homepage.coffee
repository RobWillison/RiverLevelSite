# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this

root.initMap = () ->
  map = new google.maps.Map(document.getElementById('map'), {center: {lat: 54.559322, lng: -4.174804},zoom: 6})
