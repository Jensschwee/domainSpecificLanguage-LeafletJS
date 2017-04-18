leaflet 1.0.3

include style "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
include script "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"

map worldmap startZoom 4 minZoom 1 maxZoom 19 maxNativeZoom 22 disableZoomBtn true lat 38.800425 long -77.07 "http://korona.geog.uni-heidelberg.de/tiles/roads/x={x}&y={y}&z={z}"
          
source json Earthquakes "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson" {
	variable mag
}

layer BigEQ from Earthquakes {
	filter where mag > 3.5
}

layer MidiumEQ from Earthquakes {
	filter where mag > 2.5 and mag < 3.4
}

layer SmallEQ from Earthquakes {
	filter where mag < 2.5
}

icon iconAfghanistan size 16 source "https://www.iconexperience.com/_img/v_collection_png/32x32/shadow/flag_afghanistan.png"
icon iconDenmark size 16 source "https://www.iconfinder.com/icons/96204/download/ico"

button toggles BigEQ iconAfghanistan location bottomRight
button toggles MidiumEQ iconAfghanistan location bottomRight
button toggles SmallEQ iconAfghanistan location bottomRight