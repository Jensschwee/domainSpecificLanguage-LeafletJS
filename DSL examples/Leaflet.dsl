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
	filter OrangeStyle where line = "orange"
}

layer blueLine from OU44_1{
	filter BlueStyle where line = "blue"
}

layer yellowLine from OU44_1 {
	filter YellowStyle where line = "yellow"
}

layer greenLine from OU44_1 {
	filter GreenStyle where line = "green"
}

icon iconBlue size 10 source "http://www.freeiconspng.com/uploads/button-blank-blue-icon-6.png"
icon iconYellow size 10 source "http://icons.iconarchive.com/icons/hopstarter/soft-scraps/256/Button-Blank-Yellow-icon.png"
icon iconGreen size 10 source "https://www.mouserunner.com/Icons/Shiny_Things_Preview_icon.png"
icon iconOrange size 10 source "https://upload.wikimedia.org/wikipedia/commons/4/46/Button_Icon_Orange.svg"

style defaultStyle {
	lineColor red
	lineWidth 2
	backgroundColor red
	backgroundOpacity 90%
}

style BlueStyle : defaultStyle  {
	pointerIcon iconBlue
}

style YellowStyle : defaultStyle  {
	pointerIcon iconYellow
}

style OrangeStyle : defaultStyle  {
	pointerIcon iconOrange
}

style GreenStyle : defaultStyle  {
	pointerIcon iconGreen
}

button toggles blueLine iconBlue location bottomRight
button toggles yellowLine iconYellow location bottomRight
button toggles greenLine iconGreen location topLeft
button toggles orangeLine iconOrange location topLeft