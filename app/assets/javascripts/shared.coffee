@initGoogleMap = ->
  map_element = $('#google_map').first()
  position = {lat: map_element.data('lat'), lng: map_element.data('lng')}
  map = new google.maps.Map(document.getElementById('google_map'), {
    center: position,
    zoom: 15,
    disableDefaultUI: false,
    scrollwheel: true,
    draggable: true,
  })

  if map_element.data('overlay') == 'kml'
    kmlLayer = new google.maps.KmlLayer({
      url: 'http://www.peschla.net/postal_code_areas/' + map_element.data('zip') + '.kml',
      suppressInfoWindows: true,
      map: map
    })
  else
    marker = new google.maps.Marker({
      position: position,
      map: map
    })
  end

$(document).ready ->
  $('a').filter ->
    this.href.match /commontator\/threads\/\d+/
  .click()
