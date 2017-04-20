leaflet 1.0.3

include style "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
include script "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
include script "../myJs.js"

map FF startZoom 12 minZoom 1 maxZoom 19 maxNativeZoom 22 disableZoomBtn true lat 38.800425 long -77.07 "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
          
source json a "https://www.mapbox.com/help/data/stations.geojson" {
	variable line
}

source json OU44_1 "https://www.mapbox.com/help/data/stations.geojson" {
	variable line 
}

layer orangeLine from a {
	filter defaultStyle where line = "orange"
}

layer blueLine from OU44_1{
	filter defaultStyle where line = "blue"
}

layer yellowLine from OU44_1 {
	filter defaultStyle where line = "yellow"
}

layer greenLine from OU44_1 {
	filter coolStyle where line = "green"
}

icon iconTemputur size 5 source "http://icons.iconarchive.com/icons/paomedia/small-n-flat/1024/sign-check-icon.png"
icon iconTemputur1 size 16 source "http://icons.iconarchive.com/icons/paomedia/small-n-flat/1024/sign-check-icon.png"

style defaultStyle {
	lineColor red
	lineWidth 2
	backgroundColor red
	backgroundOpacity 90%
}

style coolStyle : defaultStyle  {
	backgroundColor blue
}

button toggles blueLine iconTemputur location bottomRight
button toggles yellowLine iconTemputur location bottomRight
button toggles greenLine iconTemputur1 location topLeft
button toggles orangeLine iconTemputur1 location topLeft