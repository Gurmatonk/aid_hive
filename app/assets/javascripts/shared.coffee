@initGoogleMap = ->
  map_element = $('#google_map').first()
  map = new google.maps.Map(document.getElementById('google_map'), {
    center: {lat: map_element.data('lat'), lng: map_element.data('lng')},
    zoom: 8,
    disableDefaultUI: true,
    scrollwheel: false,
    draggable: false,
  })

  kmlLayer = new google.maps.KmlLayer({
    url: 'http://www.peschla.net/postal_code_areas/' + map_element.data('zip') + '.kml',
    suppressInfoWindows: true,
    map: map
  })

$(document).ready ->
  $('a').filter ->
    this.href.match /commontator\/threads\/\d+/
  .click()
