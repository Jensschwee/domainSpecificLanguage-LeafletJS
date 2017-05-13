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
import org.eclipse.xtext.Disjunction
import org.example.domainmodel.domainmodel.LogicExpression
import java.util.LinkedList
import javax.xml.ws.Dispatch
import org.example.domainmodel.domainmodel.AllTypes
import org.eclipse.xtext.CompositeCondition
import org.eclipse.xtext.Condition
import java.awt.CompositeContext
import org.eclipse.xtext.Conjunction
import org.example.domainmodel.domainmodel.Comparison
import org.eclipse.xtext.impl.ConditionImpl
import org.eclipse.emf.ecore.EObject
import org.example.domainmodel.domainmodel.LogicExp
import org.eclipse.emf.common.notify.Notifier
import java.util.Set
import java.util.HashSet
import java.util.HashMap
import org.example.domainmodel.domainmodel.MathOp
import org.example.domainmodel.domainmodel.MathExp
import org.example.domainmodel.domainmodel.MathTerm
import org.example.domainmodel.domainmodel.MapType
import org.example.domainmodel.domainmodel.POINT
import org.example.domainmodel.domainmodel.POLYGON
import org.example.domainmodel.domainmodel.LESS
import org.example.domainmodel.domainmodel.MORE
import org.example.domainmodel.domainmodel.EQ
import org.example.domainmodel.domainmodel.EQLESS
import org.example.domainmodel.domainmodel.EQMORE
import org.example.domainmodel.domainmodel.NOT
import org.example.domainmodel.domainmodel.NumberTypes
import org.example.domainmodel.domainmodel.BOOLEAN
import org.example.domainmodel.domainmodel.OperatorAddMinus
import org.example.domainmodel.domainmodel.MINUS
import org.example.domainmodel.domainmodel.PLUS
import org.example.domainmodel.domainmodel.MULTIPLI
import org.example.domainmodel.domainmodel.DIVISION
import org.example.domainmodel.services.DomainmodelGrammarAccess.MathFactorElements
import org.example.domainmodel.domainmodel.Value
import org.example.domainmodel.domainmodel.Filter
import org.example.domainmodel.domainmodel.CSSStyle
import org.example.domainmodel.domainmodel.LineOpacity
import org.example.domainmodel.domainmodel.LINESTRING
import org.example.domainmodel.domainmodel.MULTILINESTRING
import org.example.domainmodel.domainmodel.MULTIPOINT
import org.example.domainmodel.domainmodel.GEOMETRYCOLLECTION
import org.example.domainmodel.domainmodel.MULTIPOLYGON
import org.example.domainmodel.domainmodel.DataSourceVariable
import org.example.domainmodel.domainmodel.impl.LineColorImpl
import org.example.domainmodel.domainmodel.FilterStyle
import org.example.domainmodel.domainmodel.FilterMapType

/**
  * http://stackoverflow.com/questions/18409011/xtend-how-to-stop-a-variable-from-printing-in-output
  */
 class State {
    @Property
    var int counter
    
    @Property
    var String mapName
    
    @Property
    var Set<Transform> transforms = new HashSet();

 	@Property
    var Set<Layer> layers = new HashSet();
    
    new(int counter){
        this.counter = counter
    }
}

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class DomainmodelGenerator extends AbstractGenerator {
	var state = new State(0);
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val model = resource.allContents.filter(typeof(Model)).next
		state.mapName = resource.allContents.filter(typeof(Map)).next.mapName
		state.transforms = resource.allContents.filter(typeof(Transform)).toSet()
		state.layers = resource.allContents.filter(typeof(Layer)).toSet()
		fsa.generateFile("/Leaflet.html",generateLeafletHTML(model));
	}
	
	def generateLeafletHTML(Model model)'''
		�generateStaticHeader()�
		
		�generateInclude(model.includes)�
		
		�generateStaticHTMLBODY()�
		
			�generateMaps(model.map)�
		
			�generateModelItem(model.modelItems)�
		
		�generateStatickFooter()�'''
	
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
	�FOR styleElement : style.getStyles�	�generateCSSElement(styleElement)�
    �ENDFOR�
		return style;
	}
	'''
	
	def dispatch generateCSSElement(LineColor style) 
	'''
		style["color"] = "�style.color�";
	'''
	
	def dispatch generateCSSElement(LineWidth style) 
	'''
		style["weight"] = �style.value�;
	'''
	
	def dispatch generateCSSElement(BackgroundColor style) 
	'''
		style["fillColor"] = "�style.color�";
	'''
	
	def dispatch generateCSSElement(BackgroundOpacity style) 
	'''
		style["fillOpacity"] = �style.value/100.0�;
	'''
	
	def dispatch generateCSSElement(LineOpacity style) 
	'''
		style["opacity"] = �style.value/100.0�;
	'''
	
	def dispatch generateCSSElement(PointerIcon style) 
	'''
		style["pointerIcon"] = getIcon�style.icon.name�();
	'''
	
	def dispatch generateModelItemMember(Layer layer) '''
	�IF layer.filter.size() !== 0�
		�state.setCounter(1)�
		�FOR filter : layer.filter�
			�var expression = (filter.filterElements.findFirst[it instanceof LogicExpression] as LogicExpression)�
			�var mapType = (filter.filterElements.findFirst[it instanceof MapType] as MapType)�
			�IF expression !== null �
				�var variabels =  expression.findVariabelsForFilter�
				function layer�layer.name�Filter�state.counter�(feature) {
				        if (feature == undefined || feature.properties === undefined �IF variabels.size()  !== 0�||�ENDIF� �FOR str : variabels SEPARATOR "|| "�!feature.properties["�str�"] === undefined �ENDFOR�)
				            return false;
				            �IF(mapType !== null)�
				            if (feature.geometry.type !== "�mapType.maptypeGenerate�")
				                        return false;
				            �ENDIF�
				         �expression.generateFilterExpression�   
				        return false;
				}
				�state.setCounter(state.counter + 1)�
			�ELSEIF mapType !== null�
				 function layer�layer.name�Filter�state.counter�(feature) {
				 				            �IF(mapType !== null)�
				 				            if (feature.geometry.type === "�mapType.maptypeGenerate�")
				 				                        return true;
				 				            �ENDIF�
				 				        return false;
				 }
			�ENDIF�
		�ENDFOR�
	�ENDIF�
	'''
	
	def generateFilterExpression(LogicExpression expression)'''
	�var filter =expression.eContainer() as Filter�
	�var layer =filter.eContainer() as Layer�
	if(�expression.findSubExpression(layer)�)
	{
		return true;
	}
	'''
	
	def dispatch CharSequence findSubExpression(LogicExpression expression, Layer layer)
	{
		//DO NOTHING
	}
	
	def dispatch CharSequence findSubExpression(Comparison expression, Layer layer)
	'''�expression.left.findSubExpression(layer)��expression.operator.findSubExpression(layer)��expression.right.findSubExpression(layer)�'''	
	def dispatch CharSequence findSubExpression(LESS less, Layer layer)''' < '''
	def dispatch CharSequence findSubExpression(MORE less, Layer layer)''' > '''
	def dispatch CharSequence findSubExpression(EQ less, Layer layer)''' == '''
	def dispatch CharSequence findSubExpression(EQLESS less, Layer layer)''' <= '''
	def dispatch CharSequence findSubExpression(EQMORE less, Layer layer)''' >= '''
	def dispatch CharSequence findSubExpression(NOT less, Layer layer)''' != '''
			
	def dispatch CharSequence  findSubExpression(Disjunction expression, Layer layer)
	'''(�expression.left.findSubExpression(layer)� && �expression.right.findSubExpression(layer)�)'''
	
	def dispatch CharSequence  findSubExpression(Conjunction expression, Layer layer)
	'''(�expression.left.findSubExpression(layer)� || �expression.right.findSubExpression(layer)�)'''
	
	def dispatch CharSequence findSubExpression(AllTypes type, Layer layer)
	'''�IF(type.id !== null)��var transform = state.transforms.findFirst[it.name==type.id]��IF(transform !== null)��transform.findSubExpression(layer)��ELSE�feature.properties["�layer.datasource.variables.findFirst[it.vname == type.id].mapsto�"]�ENDIF��ELSEIF (type.string !== null)�"�type.string�"�ENDIF�'''
	
	def dispatch CharSequence findSubExpression(BOOLEAN bool, Layer layer)'''�printBOOLEAN(bool)�'''
	
	def dispatch CharSequence findSubExpression(NumberTypes num, Layer layer)
	'''�IF(num.int !== null)��printINTEGER(num.int)��ELSEIF(num.double !== null)��printDOUBLE(num.double)��ENDIF�'''
	
	def dispatch CharSequence findSubExpression(LogicExp exp, Layer layer)
	'''�IF exp.op.equals("and")�(�ENDIF��exp.left.findSubExpression(layer)��IF exp.op.equals("and")� && �ELSEIF exp.op.equals("or")� || �ENDIF��exp.right.findSubExpression(layer)��IF exp.op.equals("and")�)�ENDIF�'''
	
	def dispatch CharSequence findSubExpression(MathTerm exp, Layer layer)
	{
		if(exp.transform !== null)
		{
			exp.transform.findSubExpression(layer)
		}
	}
	
	def dispatch CharSequence findSubExpression(Transform exp, Layer layer)
	'''transform�exp.name�(feature.properties["�layer.datasource.variables.findFirst[it.vname == exp.variable].mapsto�"])'''
	
	def dispatch getMaptypeGenerate(POINT type)'''Point'''
	def dispatch getMaptypeGenerate(POLYGON type)'''Polygon'''
	def dispatch getMaptypeGenerate(LINESTRING type)'''LineString'''
	def dispatch getMaptypeGenerate(MULTILINESTRING type)'''MultiLineString'''
	def dispatch getMaptypeGenerate(MULTIPOINT type)'''MultiPoint'''
	def dispatch getMaptypeGenerate(GEOMETRYCOLLECTION type)'''GeometryCollection'''
	def dispatch getMaptypeGenerate(MULTIPOLYGON type)'''MultiPolygon'''
	
	def Set<String> findVariabelsForFilter(LogicExpression dis){
		var filter = dis.eContainer() as Filter;
		var layer =	filter.eContainer() as Layer;
		var variabels = new HashSet<String>();
		dis.findVariable(variabels, layer.datasource.variables);
		return variabels;
	}
	
	def dispatch void findVariable(Disjunction di, Set<String> variabels, List<DataSourceVariable> datasourceVariables){
		di.left.findVariable(variabels,datasourceVariables);
		di.right.findVariable(variabels,datasourceVariables);
	}
	
	def dispatch void findVariable(Conjunction con, Set<String> variabels, List<DataSourceVariable> datasourceVariables){
		con.left.findVariable(variabels,datasourceVariables);
		con.right.findVariable(variabels,datasourceVariables);
	}
	
	def dispatch void findVariable(LogicExp le, Set<String> variabels, List<DataSourceVariable> datasourceVariables){
		le.left.findVariable(variabels,datasourceVariables);
		le.right.findVariable(variabels,datasourceVariables);
	}
	
	def dispatch void findVariable(AllTypes at, Set<String> variabels, List<DataSourceVariable> datasourceVariables){
		if(at.id !== null)
		{
			var transform = state.transforms.findFirst[it.name==at.id]
			if(transform === null)
			{
				var variable = datasourceVariables.findFirst[it.vname == at.id]
				variabels.add(variable.mapsto);
			}
			else
			{
				transform.findTransformVariables(variabels, datasourceVariables);
			}
		}
	}
	
	def dispatch void findVariable(Comparison con, Set<String> variabels, List<DataSourceVariable> datasourceVariables){
		con.left.findVariable(variabels, datasourceVariables);		
		con.right.findVariable(variabels, datasourceVariables);
	}
	
	def dispatch generateModelItemMember(Button button) 
	'''�generateButton(button.btn)�
	'''
	
	def findTransformVariables(Transform transform, Set<String> variabels, List<DataSourceVariable> datasourceVariables )
	{
		var variable = datasourceVariables.findFirst[it.vname == transform.variable]
		variabels.add(variable.mapsto);
		if(transform.expression !== null)
			transform.expression.findTransforms(variabels, datasourceVariables);
	}
	
	
	def dispatch void findTransforms(MathExp mat, Set<String> variabels, List<DataSourceVariable> datasourceVariables )
	{
		//DO NOTHING	
	}
	
	def dispatch void findTransforms(Value mat, Set<String> variabels, List<DataSourceVariable> datasourceVariables )
	{
		//DO NOTHING
	}
	
	def dispatch void findTransforms(MathOp mat, Set<String> variabels, List<DataSourceVariable> datasourceVariables )
	{
		if(mat.left !== null)
			mat.left.findTransforms(variabels, datasourceVariables)
		if(mat.right !== null)	
			mat.right.findTransforms(variabels, datasourceVariables)
	}
	
	def dispatch void findTransforms(MathTerm mat, Set<String> variabels, List<DataSourceVariable> datasourceVariables )
	{
		if(mat.transform !== null)
			mat.transform.findTransformVariables(variabels, datasourceVariables);
	}
	
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
            �state.mapName�.removeLayer(layer�buttons.layer.name�);
        }
    },
	{
        icon: getEasybuttonImage�buttons.icon.name�(),
        stateName: 'detoggled',
        title: '�buttons.layer.name�',
        onClick: function (btn) {
					btn.state('toggled');
					btn.button.style.backgroundColor = 'grey';
					�state.mapName�.addLayer(layer�buttons.layer.name�);
				}
			}]
		}).addTo(�state.mapName�);
		toogle�buttons.layer.name�.button.style.backgroundColor = 'grey';
	'''
	
	def dispatch generateLocation(TOPRIGHT location) '''topright'''
	def dispatch generateLocation(TOPLEFT location) '''topleft'''
	def dispatch generateLocation(BOTTOMLEFT location) '''bottomleft'''
	def dispatch generateLocation(BOTTOMRIGHT location) '''bottomright'''
	
	def dispatch generateModelItemMember(Transform transform) '''
	 function transform�transform.name�(value) {
	 	return �transform.expression.generateTransformExp�;
	 }
	'''
	
	def dispatch CharSequence generateTransformExp(MathOp exp)
	'''(�exp.left.generateTransformExp��exp.op.generateTransformExp��exp.right.generateTransformExp�)'''
	
	def dispatch CharSequence generateTransformExp(MINUS op)'''-'''
	def dispatch CharSequence generateTransformExp(PLUS op)'''+'''
	def dispatch CharSequence generateTransformExp(MULTIPLI op)'''*'''
	def dispatch CharSequence generateTransformExp(DIVISION op)'''/'''
	def dispatch CharSequence generateTransformExp(Value value)'''value'''	
	

	def dispatch CharSequence generateTransformExp(MathTerm exp)
	'''�IF (exp.transform !== null)�transform�exp.transform.name�(value)�ENDIF�'''
	
	def dispatch CharSequence generateTransformExp(NumberTypes num)
	'''�IF(num.int !== null)��printINTEGER(num.int)��ELSEIF(num.double !== null)��printDOUBLE(num.double)��ENDIF�'''
	
	
	def dispatch generateModelItemMember(DataSource dataSoruce) '''
	var �dataSoruce.name� = null;
	�var layers = state.layers.filter[it.datasource.name === dataSoruce.name]�
	�IF layers !== null�
		�FOR l : layers�
			var layer�l.name� = null;
		�ENDFOR�
	�ENDIF�
	loadJSON("�dataSoruce.getSourceLocation�",
		(function (data) {
        �dataSoruce.name� = JSON.parse(data);
            �FOR l : layers�
				�IF l.filter.size() !== 0�
					�var expression = ( l.filter.get(0).filterElements.findFirst[it instanceof LogicExpression] as LogicExpression)�
					�var mapType = (l.filter.get(0).filterElements.findFirst[it instanceof FilterMapType] as FilterMapType)�
					�var style = (l.filter.get(0).filterElements.findFirst[it instanceof FilterStyle] as FilterStyle)�
	        		�IF expression !== null�
	        			�IF style !== null�		layer�l.name� = L.geoJson(�l.datasource.name�, { filter: layer�l.name�Filter1, style: style�style.style.name� �l.filter.get(0).generateCustumPointIcon�});
	        				�ELSE�		layer�l.name� = L.geoJson(�l.datasource.name�, { filter: layer�l.name�Filter1 �l.filter.get(0).generateCustumPointIcon�		});
	        			�ENDIF�
        			�ELSEIF mapType !== null�	
	        			�IF style !== null�		layer�l.name� = L.geoJson(�l.datasource.name�, { filter: layer�l.name�Filter1, style: style�style.style.name� �l.filter.get(0).generateCustumPointIcon�});
	        				�ELSE�		layer�l.name� = L.geoJson(�l.datasource.name�, { filter: layer�l.name�Filter1 �l.filter.get(0).generateCustumPointIcon�		});
	        			�ENDIF�
	        		�ELSE�
	        			�IF style !== null�		layer�l.name� = L.geoJson(�l.datasource.name�, { style: style�style.style.name� �l.filter.get(0).generateCustumPointIcon�});
	        				�ELSE�		layer�l.name� = L.geoJson(�l.datasource.name� �l.filter.get(0).generateCustumPointIcon�);
	        			�ENDIF�
	        		�ENDIF�
            	�ELSE�
				layer�l.name� = L.geoJson(�l.datasource.name�);
            	�ENDIF�
            	�state.counter = 0�
	            	�FOR filter : l.filter�
		            	�IF state.counter != 0�
		            		�var expression = ( filter.filterElements.findFirst[it instanceof LogicExpression] as LogicExpression)�
		            		�var mapType = (filter.filterElements.findFirst[it instanceof FilterMapType] as FilterMapType)�
		            		�var style = (filter.filterElements.findFirst[it instanceof FilterStyle] as FilterStyle)�
		            		�IF expression !== null�
		            			�IF style !== null�		L.geoJson(�l.datasource.name�, { filter: layer�l.name�Filter�state.counter+1�, style: style�style.style.name� �filter.generateCustumPointIcon�}).addTo(layer�l.name�);
		            			�ELSE�		L.geoJson(�l.datasource.name�, { filter: layer�l.name�Filter�state.counter+1� �filter.generateCustumPointIcon�}).addTo(layer�l.name�);
		            			�ENDIF�
	            			�ELSEIF mapType !== null�
		            			�IF style !== null�		L.geoJson(�l.datasource.name�, { filter: layer�l.name�Filter�state.counter+1�, style: style�style.style.name� �filter.generateCustumPointIcon�}).addTo(layer�l.name�);
		            			�ELSE�		L.geoJson(�l.datasource.name�, { filter: layer�l.name�Filter�state.counter+1� �filter.generateCustumPointIcon�}).addTo(layer�l.name�);
		            			�ENDIF�
		            		�ELSE�
		            			�IF style !== null�		L.geoJson(�l.datasource.name�, {style: style�style.style.name� �filter.generateCustumPointIcon�}).addTo(layer�l.name�);
		            			�ELSE�		L.geoJson(�l.datasource.name�).addTo(layer�l.name�, {�filter.generateCustumPointIcon�});
		            			�ENDIF�
		            		�ENDIF�
		            	�ENDIF�
		            	�state.setCounter(state.counter + 1)�
	            	�ENDFOR�
						layer�l.name�.addTo(�state.mapName�);
			�ENDFOR�
	}));
	'''
	
	def generateCustumPointIcon(Filter filter)'''
	�var style = (filter.filterElements.findFirst[it instanceof FilterStyle] as FilterStyle)�
	�IF style != null�
		�var makerName = style.style.findIconStyle�
		�IF makerName !== null�
		,
				    pointToLayer: function(feature, latlng) {
				        return L.marker(latlng, { icon: getIcon�makerName�() });
				    }
		�ENDIF�
	�ENDIF�
	'''
	
	def String findIconStyle(Styling styling)
	{
		for (element : styling.styles) {
			var results = element.findpointIcon;
			if(results !== null)
				return results;
		}
		if(styling.base !== null)
			return styling.base.findIconStyle
		return null
	}
	
	def dispatch String findpointIcon(PointerIcon style)
	{
		return style.icon.name;
	}
	
	def  dispatch String findpointIcon(CSSStyle style)
	{
		return null;
	}
	
	
	
	def generateStaticHTMLBODY() 
	'''
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
	
	def generateStatickFooter() 
	''' 
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
	
	def printDOUBLE(DOUBLE value)'''�IF(value.value.neq)�-�value.value.value�.�value.decimals��ELSE��value.value.value�.�value.decimals��ENDIF�'''
	
	def printINTEGER(INTEGER value)'''�IF(value.neq)�-�value.value��ELSE��value.value��ENDIF�'''
	
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
	
	def generateMapOptinalStartZoom(Map map)
	'''�var startZoom = map.optinals.filter(typeof(StartZoom))��IF(!startZoom.nullOrEmpty)��startZoom.get(0).zoom��ENDIF�'''
		
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
	
	def generateInclude(List<Include> includes) 
	'''�FOR i : includes�	�generateIncludeMember(i)��ENDFOR�
	'''
	
	def dispatch generateIncludeMember(Script s) 
	'''
	<script src="�s.source�"></script>
	'''
	def dispatch generateIncludeMember(Style s) '''
	<link rel="stylesheet" href="�s.source�" />
	'''
}