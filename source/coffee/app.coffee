# Init variables with defaults
data = null
width = 0
height = 0
mapZoom = 0
margin = {}
parentEl = '#viz-content'
charts = {}
latlngs = []

$(window).load -> onLoad()

onLoad = ->
  setDimensions()

  # Load data from CSV

  # Load data from google sheets
  Tabletop.init {
    key: '1nLSK8htCKnMaqdywT5v3pWg891L0ZpRmsV6Zu8e7KMY'
    simpleSheet: true
    callback: (jsondata, tabletop) ->
      data = jsondata
      vizData()
  }

  ###
  d3.csv 'data/usroadtrip.r1.csv', (csvdata) ->
    data = csvdata
    vizData()
  ###

cleanData = ->
  if data isnt null
    console.log 'Data ->', data
  else
    'No data'

vizData = ->
  $parentEl = $(parentEl)
  $parentEl.empty()

  $('#leaflet-map').width(width)
  $('#leaflet-map').height(600)


  map = L.map('leaflet-map')
  .setView([38.907192,-77.036871], 12)
  
  layer = new L.StamenTileLayer('terrain').addTo(map)

  _.each(data, (stop) ->
    console.log 'stop', stop
    #newmarker = L.marker([stop.latitude, stop.longitude])
    newmarker = L.circleMarker([stop.lat, stop.lon], {
      color: 'red'
      fill: 'blue'
      })
    newmarker.bindPopup(stop.locationname)

    newmarker.addTo(map)

    latlngpush = new L.LatLng(+stop.lat, +stop.lon)

    latlngs.push(latlngpush)

  )

  console.log 'latlngs', JSON.stringify(latlngs)

  
  polyline = L.polyline(latlngs,
    {
      color: 'red'
      weight: 6
      opacity: 0.5
      lineJoin: 'round'
    }
  ).addTo(map)

  console.log polyline

  #zoom the map to the polyline
  map.fitBounds(polyline.getBounds())
  
setDimensions = ->
  $parentEl = $(parentEl)
  width = $parentEl.width() #500
  height = width * 0.6

  # Mobile / Desktop breakpoints
  if width > 649
    console.log width + 'px ==> Desktop'
    mobile = false
    mapZoom = 900
    margin =
      left: 16
      right: 16
      top: 16
      bottom: 16
  else
    console.log width + 'px ==> Mobile'
    mobile = true
    mapZoom = 400
    margin =
      left: 4
      right: 4
      top: 4
      bottom: 4

# Example GA completion event
#ga 'Items', 'finished-interactive', 'INTERACTIVE--PROJECT--NAME', 1
#$(window).click ->
  # Example GA interaction event
  #ga 'Items', 'click-interactive', 'DESCRIPTION--OF--CLICK', 1