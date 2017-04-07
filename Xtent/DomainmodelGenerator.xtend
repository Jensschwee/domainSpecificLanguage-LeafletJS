/*
 * generated by Xtext 2.11.0
 */
package org.example.domainmodel.generator

import java.util.List
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.example.domainmodel.domainmodel.ApiKey
import org.example.domainmodel.domainmodel.Attribution
import org.example.domainmodel.domainmodel.BackgroundColor
import org.example.domainmodel.domainmodel.BackgroundOpacity
import org.example.domainmodel.domainmodel.Button
import org.example.domainmodel.domainmodel.DOUBLE
import org.example.domainmodel.domainmodel.DataSource
import org.example.domainmodel.domainmodel.DisableZoomBtn
import org.example.domainmodel.domainmodel.DoubleClickZoom
import org.example.domainmodel.domainmodel.DraggingDisable
import org.example.domainmodel.domainmodel.FALSE
import org.example.domainmodel.domainmodel.INTEGER
import org.example.domainmodel.domainmodel.Icon
import org.example.domainmodel.domainmodel.Include
import org.example.domainmodel.domainmodel.KeyValue
import org.example.domainmodel.domainmodel.KeyboardDisable
import org.example.domainmodel.domainmodel.Layer
import org.example.domainmodel.domainmodel.LineColor
import org.example.domainmodel.domainmodel.LineWidth
import org.example.domainmodel.domainmodel.Map
import org.example.domainmodel.domainmodel.MapContainterOptions
import org.example.domainmodel.domainmodel.MapTilelayerOptions
import org.example.domainmodel.domainmodel.MaxNativeZoom
import org.example.domainmodel.domainmodel.MaxZoom
import org.example.domainmodel.domainmodel.MinZoom
import org.example.domainmodel.domainmodel.Model
import org.example.domainmodel.domainmodel.ModelItems
import org.example.domainmodel.domainmodel.PointerIcon
import org.example.domainmodel.domainmodel.Script
import org.example.domainmodel.domainmodel.ScrollWheelZoom
import org.example.domainmodel.domainmodel.StartZoom
import org.example.domainmodel.domainmodel.Style
import org.example.domainmodel.domainmodel.Styling
import org.example.domainmodel.domainmodel.TRUE
import org.example.domainmodel.domainmodel.TouchZoomDisable
import org.example.domainmodel.domainmodel.Transform
import org.example.domainmodel.domainmodel.ToggleButton
import org.example.domainmodel.domainmodel.TOPRIGHT
import org.example.domainmodel.domainmodel.TOPLEFT
import org.example.domainmodel.domainmodel.BOTTOMLEFT
import org.example.domainmodel.domainmodel.BOTTOMRIGHT

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
 
 class State {
    @Property
    var int counter
    
    @Property
    var String mapName
    

    new(int counter){
        this.counter = counter
    }
}

class DomainmodelGenerator extends AbstractGenerator {
	var state = new State(0);
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val model = resource.allContents.filter(typeof(Model)).next
		state.mapName = resource.allContents.filter(typeof(Map)).next.mapName
		
		fsa.generateFile("/Leaflet.html",generateLeafletHTML(model));
	}
	
	def generateLeafletHTML(Model model)'''
		�generateStaticHeader()�
		�generateInclude(model.includes)�
		�generateStaticHTMLBODY()�
		�generateMaps(model.map)�
		�generateModelItem(model.modelItems)�
		�generateStatickFooter()�
	'''
	
	def generateModelItem(EList<ModelItems> modelItems)'''
	�FOR mi : modelItems�
		�generateModelItemMember(mi)�
	�ENDFOR�
	'''
	
	def dispatch generateModelItemMember(Icon icon) '''
	function getIcon�icon.name�() {
	        return L.icon({
	            iconUrl: '�icon.source�',
	            iconSize: [�icon.size�, �icon.size�]
	        });
	    }
	    
    function getEasybuttonImage�icon.name�() {
            var height = �icon.size�;
            var width = �icon.size�;
            var imageSrc = '�icon.source�';
            return '<div><img src="' + imageSrc + '" width="' + width + '" height="' + height + '"/></div>';
    }
	'''
	
	def dispatch generateModelItemMember(Styling style) '''
	function style�style.name�() {
		�IF style.base != null�
			var style = style�style.base.name�();
		�ELSE�
			var style = {};
		�ENDIF�
	        �FOR styleElement : style.getStyles�
	        �generateCSSElement(styleElement)�
	        �ENDFOR�
	        return style;
	    }
	'''
	
	def dispatch generateCSSElement(LineColor style) '''
	style["color"] = "�style.value�";
	'''
	
	def dispatch generateCSSElement(LineWidth style) '''
	style["weight"] = "�style.value�px";
	'''
	
	def dispatch generateCSSElement(BackgroundColor style) '''
	style["fillColor"] = "�style.color�";
	'''
	
	def dispatch generateCSSElement(BackgroundOpacity style) '''
	style["opacity"] = "�style.value�%";
	'''
	
	def dispatch generateCSSElement(PointerIcon style) '''
	style["pointerIcon"] = getIcon�style.icon.name�();
	'''
	
	def dispatch generateModelItemMember(Layer layer) '''
	
	var layer�layer.name� = L.geoJson(�layer.map.name�, { filter: layer�layer.name�Filter1, style: style�layer.filter.get(0).style.name�() });
	�state.counter = 0�
	�FOR l : layer.filter�
	�IF state.counter != 0�
		L.geoJson(OU44, { filter: layer�layer.name�Filter�state.counter+1�, style: style�layer.filter.get(0).style.name�() }).addTo(layer�layer.name�);
	�ENDIF�
	�state.setCounter(state.counter + 1)�
	�ENDFOR�
	layer�layer.name�.addTo(�state.mapName�);
	
	�state.setCounter(1)�
	�/*FOR filter : layer.filter�
	function layer�layer.name�Filter�counter�(feature) {
	        if (feature == undefined || �FOR variable : filter.expression�  �ENDFOR�)
	            return false;
	        if (transformCelciusToFahrenheit(feature.properties.Temperature) > 50 && feature.properties.Motion !== 0)
	            return true;
	        return false;
    }
    �counter++�
	�ENDFOR*/�
	'''
	
	def dispatch generateModelItemMember(Button button) '''
	�generateButton(button.btn)�
	'''
	
	def generateButton(ToggleButton buttons)'''
	var toogle�buttons.layer.name� = L.easyButton({
	        id: 'easy-button',
	        position: '�generateLocation(buttons.location)�',
	        states: [{
	                icon: getEasybuttonImage�buttons.icon.name�(),
	                stateName: 'toggled',
	                title: '�buttons.layer.name�',
	                onClick: function (btn) {
	                    btn.state('detoggled');
	                    btn.button.style.backgroundColor = 'white';
	                    �state.mapName�.removeLayer(�buttons.layer.name�);
	                }
	            },
	            {
	                icon: getEasybuttonImage�buttons.icon.name�(),
	                stateName: 'detoggled',
	                title: '�buttons.layer.name�',
	                onClick: function (btn) {
	                    btn.state('toggled');
	                    btn.button.style.backgroundColor = 'grey';
	                    �state.mapName�.addLayer(�buttons.layer.name�);
	                }
	            }
	        ]
	    }).addTo(�state.mapName�);
	    toogle�buttons.layer.name�.button.style.backgroundColor = 'grey';
	'''
	
	def dispatch generateLocation(TOPRIGHT location) '''topright'''
	def dispatch generateLocation(TOPLEFT location) '''topleft'''
	def dispatch generateLocation(BOTTOMLEFT location) '''bottomleft'''
	def dispatch generateLocation(BOTTOMRIGHT location) '''bottomright'''
	
	def dispatch generateModelItemMember(Transform transform) '''
	'''
	
	def dispatch generateModelItemMember(DataSource dataSoruce) '''
	var �dataSoruce.name� = null;
    loadJSON("�dataSoruce.getSourceLocation�",
        (function (data) {
            �dataSoruce.name� = JSON.parse(data);
    }));
	'''
	
	
	def generateStaticHTMLBODY() '''
	</head>
		<body>
		    <div id="map">
		    </div>
		</body>
		<script>
		    function loadJSON(url, callback) {
		            var xobj = new XMLHttpRequest();
		            xobj.overrideMimeType("application/javascipt");
		            //xobj.responseType = 'jsonp';
		            xobj.open('GET', url, true);
		            xobj.onreadystatechange = function () {
		                if (xobj.readyState == 4 && xobj.status == "200") {
		                    // .open will NOT return a value but simply returns undefined in async mode so use a callback
		                    //console.log(JSON.parse(xobj.responseText));
		                    //return xobj.responseText;
		                   callback(xobj.responseText);
		                }
		            }
		            xobj.send(null);
		        }
	'''
	
	def generateStatickFooter() ''' 
		</script>
	</html>
	'''
	
	def generateMaps(Map map) '''
	var �map.mapName� = L.map('map', {
		�generateMapContainterOptions(map.optinals.filter(typeof(MapContainterOptions)).toList())�
	}).setView([�printDOUBLE(map.location.lat)�, �printDOUBLE(map.location.long)�], �generateMapOptinalStartZoom(map)�);
	
	L.tileLayer('�map.mapSource�', {
 		�generateMapTilelayerOptions(map.optinals.filter(typeof(MapTilelayerOptions)).toList())�
	}).addTo(�map.mapName�);
	'''
	
	def generateMapTilelayerOptions(List<MapTilelayerOptions> mapTilelayerOptions)'''
		�FOR m : mapTilelayerOptions SEPARATOR ','� �generateMapTilelayerOptionsMember(m)�
		�ENDFOR�
	'''
	
	def printDOUBLE(DOUBLE value)'''
	�IF(value.value.neq)�
	-�value.value.value�.�value.decimals�
	�ELSE�
	�value.value.value�.�value.decimals�
	�ENDIF�
	'''
	
	def printINTEGER(INTEGER value)'''
	�IF(value.neq)�
	-�value.value�
	�ELSE�
	�value.value�
	�ENDIF�
	'''
	
	def dispatch printBOOLEAN(TRUE value)''' true '''
	
	def dispatch printBOOLEAN(FALSE value)''' false '''
	
	
	def dispatch generateMapTilelayerOptionsMember(MinZoom s)'''
	minZoom : �s.zoom�
	'''
	
	def dispatch generateMapTilelayerOptionsMember(MaxZoom s)'''
	maxZoom : �s.zoom�
	'''
	
	def dispatch generateMapTilelayerOptionsMember(MaxNativeZoom s)'''
	maxNativeZoom : �s.zoom�
	'''
	
	def dispatch generateMapTilelayerOptionsMember(ApiKey s)'''
	apikey : '�s.apikey�'
	'''
	
	def dispatch generateMapTilelayerOptionsMember(Attribution s)'''
	attribution : �s.attribution� 
	'''
	
	def dispatch generateMapTilelayerOptionsMember(KeyValue s)''' �s.key� : �s.value� '''
	
	def generateMapContainterOptions(List<MapContainterOptions> mapContainterOptions)'''
		�FOR m : mapContainterOptions SEPARATOR ','�
			�generateMapContainterOptionsMember(m)�
		�ENDFOR�
	'''
	
	def dispatch generateMapContainterOptionsMember(ScrollWheelZoom s)'''
	scrollWheelZoom : �printBOOLEAN(s.inactive)�
	'''
	
	def dispatch generateMapContainterOptionsMember(DoubleClickZoom s)'''
	doubleClickZoom : �printBOOLEAN(s.inactive)�
	'''
	
	def dispatch generateMapContainterOptionsMember(DisableZoomBtn s)'''
	zoomControl : �printBOOLEAN(s.inactive)�
	'''
	
	def dispatch generateMapContainterOptionsMember(KeyboardDisable s)'''
	keyboard : �printBOOLEAN(s.inactive)�
	'''
	
	def dispatch generateMapContainterOptionsMember(TouchZoomDisable s)'''
	touchZoom : �printBOOLEAN(s.inactive)�
	'''
	
	def dispatch generateMapContainterOptionsMember(DraggingDisable s)'''
	draggable :  �printBOOLEAN(s.inactive)�
	'''
	
	def generateMapOptinalStartZoom(Map map)'''
		�var startZoom = map.optinals.filter(typeof(StartZoom))�
		�IF(!startZoom.nullOrEmpty)�
		�startZoom.get(0).zoom�
		�ENDIF�
	'''
		
	def generateStaticHeader()'''
	<!DOCTYPE html>
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
			<link rel="stylesheet" href="https://unpkg.com/leaflet@1.0.3/dist/leaflet.css" />
		    <link rel="stylesheet" href="https://unpkg.com/leaflet-easybutton@2.0.0/src/easy-button.css">
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
			<script src="https://unpkg.com/leaflet@1.0.3/dist/leaflet.js"></script>
		    <script src="https://unpkg.com/leaflet-easybutton@2.0.0/src/easy-button.js"></script>
			<title>Leaflet DSL</title>
		    <style type="text/css">
		        html, body {
		            height: 100%;
		            margin: 0;
		        }
		        #map {
		            min-height: 100%;
		        }
			</style>
	'''
	
	def generateInclude(List<Include> includes) '''
	�FOR i : includes�
		�generateIncludeMember(i)�
	�ENDFOR�
	'''
	
	def dispatch generateIncludeMember(Script s) '''
	<script src="�s.source�"/>
	'''
	def dispatch generateIncludeMember(Style s) '''
    <link rel="stylesheet" href="�s.source�" />
	'''
}