leaflet "1.0.3"

include style "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
include script "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"

map worldmap startZoom 4 minZoom 1 maxZoom 19 maxNativeZoom 22 disableZoomBtn true lat 55.609991 long 12.690006  "http://{s}.tile.opentopomap.org/{z}/{x}/{y}.png"


var FullEuMembers := ["Denmark", "Ireland", "Sweden", "Germany", "Poland", "Luxembourg", "Finland", "France", "Spain", "Greece", "Netherlands", "Malta",
					  "Italy", "Austria", "Belgium", "Bulgaria", "Croatia", "Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania",
					  "Portugal", "Romania", "Slovakia", "Slovenia"]

var PostUssrCountries := ["Armenia", "Azerbaijan", "Belarus", "Estonia", "Georgia", "Kazakhstan", "Kyrgyzstan", "Latvia", "Lithuania", "Moldova", "Russia",
						  "Tajikistan", "Turkmenistan", "Ukraine", "Uzbekistan"]

source geojson TheWorld "https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json" {
	var name
}

layer Afghanistan from TheWorld {
	filter defaultStyle where name = "Afghanistan"
}

layer EU from TheWorld {
	filter blue where name contains FullEuMembers
	filter blueOpacityMax where name = "United Kingdom"
}

layer USSR from TheWorld {
	filter red where name contains PostUssrCountries
}

layer PostUssrEuCountries from TheWorld {
	filter blueRed where name contains FullEuMembers intersect PostUssrCountries
}

layer CombinedUssrEuCountriesWithoutDenmark from TheWorld {
	filter yellow where name contains FullEuMembers union (PostUssrCountries complement ["Russia"])
}

layer Denmark from TheWorld {
	filter red where name = "Denmark"
}

layer Greenland from TheWorld {
	filter green where name = "Greenland"
}

style defaultStyle {
	backgroundColor black
	backgroundOpacity 50%
	lineColor black
	lineOpacity 40%
}

style red : defaultStyle {
	backgroundColor red
	lineColor red
	backgroundOpacity 90%
	lineWidth 5
}

style blue : red {
	backgroundColor blue
	lineColor blue
}

style blueRed : blue {
	backgroundColor blue
	lineColor red
}

style blueOpacityMax : blue {
	backgroundOpacity 0%
}

style green : defaultStyle {
	backgroundColor green
}

style yellow : defaultStyle {
	backgroundColor yellow
}

icon iconAfghanistan size 16 source "https://www.iconexperience.com/_img/v_collection_png/32x32/shadow/flag_afghanistan.png"
icon iconDenmark size 16 source "https://www.iconfinder.com/icons/96204/download/ico"
icon iconEU size 16 source "https://cdn4.iconfinder.com/data/icons/flat-circle-flag/182/circle_flag_europe_eu-512.png"
icon iconGreenland size 16 source "http://icons.iconseeker.com/png/fullsize/rounded-world-flags/greenland-flag.png"
icon iconUssr size 16 source "https://cdn0.iconfinder.com/data/icons/black-religious-icons/256/Communism.png"
icon iconUssrEu size 16 source "http://sheikyermami.com/wp-content/uploads/2016/05/eussr-flag.jpg"
icon iconAll size 16 source "http://sensatejournal.com/wp-content/themes/sensate/images/icon_all.png"

button toggles Afghanistan iconAfghanistan location bottomRight
button toggles Denmark iconDenmark location bottomRight
button toggles EU iconEU location topRight
button toggles USSR iconUssr location topRight
button toggles PostUssrEuCountries iconUssrEu location topRight
button toggles CombinedUssrEuCountriesWithoutDenmark iconAll location topRight
button toggles Greenland iconGreenland location bottomLeft
