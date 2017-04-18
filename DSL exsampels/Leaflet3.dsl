leaflet 1.0.3

include style "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
include script "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"

map worldmap startZoom 4 minZoom 1 maxZoom 19 maxNativeZoom 22 disableZoomBtn true lat 38.800425 long -77.07 "http://korona.geog.uni-heidelberg.de/tiles/roads/x={x}&y={y}&z={z}"
          
source json Earthquakes "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson" {
	variable mag
}

transform DobbelRigMag mag value * 2

layer BigEQ from Earthquakes {
	filter BigEqStyle where DobbelRigMag > 3.5
}

layer MidiumEQ from Earthquakes {
	filter MidiumEQStyle where mag > 2.5 and mag < 3.4
}

layer SmallEQ from Earthquakes {
	filter SmallEQStyle where MagMulti < 2.5
}

style MidiumEQStyle{
	pointerIcon iconMidiumEQ
}

style BigEqStyle{
	pointerIcon iconBigEQ
}

style SmallEQStyle{
	pointerIcon iconBigEQ
}

icon iconBigEQ size 16 source "http://embed.widencdn.net/img/americanredcross/8acomfees0/486x486px/mobile-app-earthquake.jpg?keep=c&quality=100&u=r5akkb"
icon iconMidiumEQ size 16 source "http://res.cloudinary.com/dk-find-out/image/upload/q_80,w_160/Earthquake-icon_npnjt2.png"
icon iconSmallEQ size 16 source "http://www.mapofearthquakes.com/img/EarthQuakeIcon1.png"


button toggles BigEQ iconBigEQ location bottomRight
button toggles MidiumEQ iconMidiumEQ location bottomRight
button toggles SmallEQ iconSmallEQ location bottomRight