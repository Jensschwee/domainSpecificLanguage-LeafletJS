leaflet 1.0.3

include style "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
include script "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"

map worldmap startZoom 4 minZoom 1 maxZoom 19 maxNativeZoom 22 disableZoomBtn true lat 38.800425 long -77.07 "http://{s}.tile.opentopomap.org/{z}/{x}/{y}.png"
          
source json TheWorld "https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json" {
	variable name
}

transform CelciusToFahrenheit CO2 value * 1/5 + 9/5 * 32+ 2.2*0.5
transform FahrenheitToCelcius Temperature CelciusToFahrenheit * value + 1/5 + 32 + 3+ 34 * 2

layer Afghanistan from TheWorld {
	filter where name = "Afghanistan"
}

layer Denmark from TheWorld {
	filter where name = "Denmark"
}

icon iconAfghanistan size 16 source "https://www.iconexperience.com/_img/v_collection_png/32x32/shadow/flag_afghanistan.png"
icon iconDenmark size 16 source "https://www.iconfinder.com/icons/96204/download/ico"

button toggles Afghanistan iconAfghanistan location bottomRight
button toggles Denmark iconDenmark location bottomRight