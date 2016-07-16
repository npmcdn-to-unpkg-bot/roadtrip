var charts, cleanData, data, height, latlngs, mapZoom, margin, onLoad, parentEl, setDimensions, vizData, width;

data = null;

width = 0;

height = 0;

mapZoom = 0;

margin = {};

parentEl = '#viz-content';

charts = {};

latlngs = [];

$(window).load(function() {
  return onLoad();
});

onLoad = function() {
  setDimensions();
  return Tabletop.init({
    key: '1nLSK8htCKnMaqdywT5v3pWg891L0ZpRmsV6Zu8e7KMY',
    simpleSheet: true,
    callback: function(jsondata, tabletop) {
      data = jsondata;
      return vizData();
    }
  });

  /*
  d3.csv 'data/usroadtrip.r1.csv', (csvdata) ->
    data = csvdata
    vizData()
   */
};

cleanData = function() {
  if (data !== null) {
    return console.log('Data ->', data);
  } else {
    return 'No data';
  }
};

vizData = function() {
  var $parentEl, layer, map, polyline;
  $parentEl = $(parentEl);
  $parentEl.empty();
  $('#leaflet-map').width(width);
  $('#leaflet-map').height(600);
  map = L.map('leaflet-map').setView([38.907192, -77.036871], 12);
  layer = new L.StamenTileLayer('terrain').addTo(map);
  _.each(data, function(stop) {
    var latlngpush, newmarker;
    console.log('stop', stop);
    newmarker = L.circleMarker([stop.lat, stop.lon], {
      color: 'red',
      fill: 'blue'
    });
    newmarker.bindPopup(stop.locationname);
    newmarker.addTo(map);
    latlngpush = new L.LatLng(+stop.lat, +stop.lon);
    return latlngs.push(latlngpush);
  });
  console.log('latlngs', JSON.stringify(latlngs));
  polyline = L.polyline(latlngs, {
    color: 'red',
    weight: 6,
    opacity: 0.5,
    lineJoin: 'round'
  }).addTo(map);
  console.log(polyline);
  return map.fitBounds(polyline.getBounds());
};

setDimensions = function() {
  var $parentEl, mobile;
  $parentEl = $(parentEl);
  width = $parentEl.width();
  height = width * 0.6;
  if (width > 649) {
    console.log(width + 'px ==> Desktop');
    mobile = false;
    mapZoom = 900;
    return margin = {
      left: 16,
      right: 16,
      top: 16,
      bottom: 16
    };
  } else {
    console.log(width + 'px ==> Mobile');
    mobile = true;
    mapZoom = 400;
    return margin = {
      left: 4,
      right: 4,
      top: 4,
      bottom: 4
    };
  }
};
