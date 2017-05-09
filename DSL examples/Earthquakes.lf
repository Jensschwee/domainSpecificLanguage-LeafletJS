leaflet "1.0.3"

include style "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
include script "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"

map worldmap startZoom 4 minZoom 1 maxZoom 19 maxNativeZoom 22 disableZoomBtn true lat 38.800425 long -77.07 "http://korona.geog.uni-heidelberg.de/tiles/roads/x={x}&y={y}&z={z}"

source geojson Earthquakes "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson" {
	variable mag
	variable tsunami
	variable magType
	variable cdi
	variable alert
	variable status
	variable sig
	variable net
	variable time
}

transform dataYear time where value / (31556926 * 1000) + 1970

layer BigEQ from Earthquakes {
	filter BigEqStyle where mag > 5.0 and (magType = "mb_lg" or magType = "ml")
	filter EQStyle where mag > 5.0 and magType = "mwr" and (sig > 100 or cdi != 2.0)
}

layer Tsunamis from Earthquakes {
	filter TsunamiStyle where tsunami = true
}

layer ThisYear from Earthquakes {
	filter EQStyle where dataYear > 2016 and dataYear < 2018
}

style TsunamiStyle{
	pointerIcon iconTsunami
}

style BigEqStyle: EQStyle{
	pointerIcon iconBigEQ
}

style EQStyle{
	pointerIcon iconAll
}

icon iconBigEQ size 16 source "http://embed.widencdn.net/img/americanredcross/8acomfees0/486x486px/mobile-app-earthquake.jpg?keep=c&quality=100&u=r5akkb"
icon iconTsunami  size 16 source "https://d30y9cdsu7xlg0.cloudfront.net/png/4251-200.png"
icon iconAll size 20 source "https://cdn3.iconfinder.com/data/icons/earthquake/500/earthquake-24-512.png"

button toggles BigEQ iconBigEQ location bottomRight
button toggles Tsunamis iconTsunami location bottomRight
button toggles ThisYear iconAll location bottomRight