leaflet 1.0.3

include style "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
include script "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
include script "../myJs.js"

map FF startZoom 12 minZoom 1 maxZoom 19 maxNativeZoom 22 disableZoomBtn true lat 55.4 long 10.3 "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"

source json a "https://www.mapbox.com/help/data/stations.geojson" {
	variable Temperature
	variable CO2
	variable Lux
}

source json OU44_1 "https://www.mapbox.com/help/data/stations.geojson" {
	variable Temperature 
	variable Motion
}

transform CelciusToFahrenheit CO2   value * 1/5 + 9/5 * 32+ 2.2*0.5
transform FahrenheitToCelcius Temperature CelciusToFahrenheit * value + 1/5 + 32 + 3+ 34 * 2

layer fahrenheitLayer from OU44_1 {
	filter defaultStyle where Motion > CelciusToFahrenheit and (CO2 <> 2.2 or Motion = true and Fisk != "jksg") and CO2 = false 
}

icon iconTemputur size 5 source "http://icons.iconarchive.com/icons/paomedia/small-n-flat/1024/sign-check-icon.png"
icon iconTemputur1 size 7 source "http://icons.iconarchive.com/icons/paomedia/small-n-flat/1024/sign-check-icon.png"

style defaultStyle {
	lineColor red
	lineWidth 2
	backgroundColor red
	backgroundOpacity 90%
}

style coolStyle : defaultStyle  {
	backgroundColor blue
	pointerIcon iconTemputur
}

button toggles fahrenheitLayer iconTemputur1 location bottomRight