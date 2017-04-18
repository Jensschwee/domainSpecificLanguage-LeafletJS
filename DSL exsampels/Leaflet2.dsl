leaflet 1.0.3

include style "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
include script "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"

map worldmap startZoom 4 minZoom 1 maxZoom 19 maxNativeZoom 22 disableZoomBtn true lat 55.609991 long 12.690006  "http://{s}.tile.opentopomap.org/{z}/{x}/{y}.png"

source json TheWorld "https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json" {
	variable name
}

layer Afghanistan from TheWorld {
	filter defaultStyle where name = "Afghanistan"
}

layer Denmark from TheWorld {
	filter red where name = "Denmark"
}

style defaultStyle {
	backgroundColor black	
	backgroundOpacity 50%
	lineColor black
	lineOpacity 40%
}

style red : defaultStyle{
	backgroundColor red	
	backgroundOpacity 90%
}

icon iconAfghanistan size 16 source "https://www.iconexperience.com/_img/v_collection_png/32x32/shadow/flag_afghanistan.png"
icon iconDenmark size 16 source "https://www.iconfinder.com/icons/96204/download/ico"

button toggles Afghanistan iconAfghanistan location bottomRight
button toggles Denmark iconDenmark location bottomRight