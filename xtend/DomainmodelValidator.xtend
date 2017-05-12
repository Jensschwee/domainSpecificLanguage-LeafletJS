/*
 * generated by Xtext 2.11.0
 */
package org.example.domainmodel.validation

import org.eclipse.xtext.validation.Check
import org.example.domainmodel.domainmodel.Filter
import org.example.domainmodel.domainmodel.Layer
import org.example.domainmodel.domainmodel.DataSourceVariable
import org.eclipse.emf.common.util.EList
import java.util.Set
import java.util.HashSet
import org.eclipse.xtext.Disjunction
import org.eclipse.xtext.Conjunction
import org.example.domainmodel.domainmodel.LogicExp
import org.example.domainmodel.domainmodel.LogicExpression
import org.example.domainmodel.domainmodel.AllTypes
import org.example.domainmodel.domainmodel.Comparison
import org.example.domainmodel.domainmodel.Transform
import org.example.domainmodel.domainmodel.MathOp
import org.example.domainmodel.domainmodel.MathTerm
import javax.swing.text.LayeredHighlighter.LayerPainter
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.EClass
import org.example.domainmodel.domainmodel.DomainmodelPackage
import org.example.domainmodel.domainmodel.DataSource
import org.example.domainmodel.domainmodel.Value
import org.example.domainmodel.domainmodel.Style
import org.example.domainmodel.domainmodel.Styling
import org.example.domainmodel.domainmodel.MathExp
import org.example.domainmodel.domainmodel.DataSourceVariableType
import org.example.domainmodel.domainmodel.BOOLEAN
import org.example.domainmodel.domainmodel.Bool
import org.example.domainmodel.domainmodel.impl.BoolImpl
import org.example.domainmodel.domainmodel.LESS
import org.example.domainmodel.domainmodel.NOT
import org.example.domainmodel.domainmodel.EQMORE
import org.example.domainmodel.domainmodel.EQLESS
import org.example.domainmodel.domainmodel.EQ
import org.example.domainmodel.domainmodel.MORE
import org.example.domainmodel.domainmodel.LeafletVersion

public enum DataTypes {
    BOOLIAN, STRING, NUMBER
}

class StateClass {  
    @Property
    var Set<Transform> transforms = new HashSet();
     @Property
    var Set<DataSource> datasources = new HashSet();
    
}

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class DomainmodelValidator extends AbstractDomainmodelValidator {
	
//	public static val INVALID_NAME = 'invalidName'
//
//	@Check
//	def checkGreetingStartsWithCapital(Greeting greeting) {
//		if (!Character.isUpperCase(greeting.name.charAt(0))) {
//			warning('Name should start with a capital', 
//					DomainmodelPackage.Literals.GREETING__NAME,
//					INVALID_NAME)
//		}
//	}

	var state = new StateClass();
	
	@Check
	def checkLeafletVersion(LeafletVersion vesion)
	{
		if(!vesion.version.equals("1.0.3"))
		{
			info("Only supports the version 1.0.3", DomainmodelPackage$Literals::LEAFLET_VERSION__VERSION)
		}
	}

	def Set<String> findVariabelsForFilter(LogicExpression dis){
			var variabels = new HashSet<String>();
			dis.findFilterVariables(variabels);
			return variabels;
	}

	def Set<String> findFilterVariables(LogicExpression dis) {
		var variabels = new HashSet<String>();
		dis.findFilterVariables(variabels);
		return variabels;
	}
	
	def dispatch void findFilterVariables(Disjunction di, Set<String> variabels){
		di.left.findFilterVariables(variabels);
		if(di.right !== null)
			di.right.findFilterVariables(variabels);
	}
	
	def dispatch void findFilterVariables(Conjunction con, Set<String> variabels){
		con.left.findFilterVariables(variabels);
		if(con.right !== null)
			con.right.findFilterVariables(variabels);
	}
	
	def dispatch void findFilterVariables(LogicExp le, Set<String> variabels){
		le.left.findFilterVariables(variabels);
		if(le.right !== null)
			le.right.findFilterVariables(variabels);
	}
	
	def dispatch void findFilterVariables(AllTypes at, Set<String> variabels){
		if(!at.id.isNullOrEmpty())
		{
			var transform = state.transforms.findFirst[it.name==at.id]
			if(transform === null)
			{
				variabels.add(at.id);
			}
			else
			{
				transform.findTransformVariables(variabels);
			}
		}
	}
	
	def findTransformVariables(Transform transform, Set<String> variabels)
	{
		variabels.add(transform.variable);
		if(transform.expression !== null)
			transform.expression.findTransforms(variabels);
	}
	
	def dispatch void findTransforms(Value mat, Set<String> variabels)
	{
		
	}
	
	def dispatch void findTransforms(MathOp mat, Set<String> variabels)
	{
		if(mat.left !== null)
			mat.left.findTransforms(variabels)
		if(mat.right !== null)	
			mat.right.findTransforms(variabels)
	}
	
	def dispatch void findTransforms(MathTerm mat, Set<String> variabels)
	{
		if(mat.transform !== null)
			mat.transform.findTransformVariables(variabels);
	}
	
	def dispatch void findFilterVariables(Comparison con, Set<String> variabels){
		con.left.findFilterVariables(variabels);
		if(con.right !== null)
			con.right.findFilterVariables(variabels);
	}
	
	@Check
	def checkFilterDatasoruces(Filter filter) {
		if(filter.expression !== null )
		{
			var layer =	filter.eContainer() as Layer;
			var variables =  filter.expression.findVariabelsForFilter;
			var datasoruceVar = new HashSet<String>;
			
			for (variable : layer.datasource.variables)
			{
				datasoruceVar.add(variable.vname);
			}
			for (variable : variables)
			{
				if(!datasoruceVar.contains(variable))
					error("All variables must be defined under the datasource: \n Datasource '" +  layer.datasource.name + "' does not have variable '" + variable + "'", DomainmodelPackage$Literals::FILTER__EXPRESSION);		 	 
			}
			filter.expression.checkDatatypeExp(layer.datasource.variables);
		 }
	}
	
	@Check
	def checkTransform(Transform transform) {
		state.transforms.add(transform);
		
	}
	
	@Check
	def checkStyling(Styling styling) {
		var stylings = new HashSet<String>();
		stylings.add(styling.name);
		if(styling.base !== null)
		{
			styling.base.checkSubStyle(stylings);
		}
	}
	
	def checkSubStyle(Styling styling, Set<String> stylings)
	{
		if(stylings.contains(styling.name))
		{
			error("Style may not have circular references Style: '" +  styling.name +"' have", DomainmodelPackage$Literals::STYLING__NAME);		 	 
		}
		else
		{
			stylings.add(styling.name);
			if(styling.base !== null)
			{
				styling.base.checkSubStyle(stylings);
			}
		}
	}
	
	@Check
	def addDataSourceToList(DataSource datasource) {
		state.datasources.add(datasource);
	}
	
	def void checkDatatypeExp(LogicExpression exp,EList<DataSourceVariable> variables) {
		exp.checkDatatypeFilterExp(variables);
	}
	
	def dispatch DataTypes checkDatatypeFilterExp(LogicExp exp,EList<DataSourceVariable> variables) {
		exp.left.checkDatatypeFilterExp(variables);
		if(exp.right !== null)
		{
			exp.right.checkDatatypeFilterExp(variables);
			//type1.checkDatatypes(type2);
		}
		return null;
	}
	
	def dispatch DataTypes checkDatatypeFilterExp(Comparison com, EList<DataSourceVariable> variables){
		var type1 = com.left.checkDatatypeFilterExp(variables);
		if(com.right !== null && com.operator !== null)
		{
			var type2 = com.right.checkDatatypeFilterExp(variables);
			com.operator.checkDatatypes(type1, type2);
			//type1.checkDatatypes(type2);
		}
		return null;
	}
	
	def dispatch DataTypes checkDatatypeFilterExp(Disjunction di, EList<DataSourceVariable> variables){
		di.left.checkDatatypeFilterExp(variables);
		if(di.right !== null)
		{
			di.right.checkDatatypeFilterExp(variables);
			//type1.checkDatatypes(type2);
		}
		return null;
	}
	
	def dispatch DataTypes checkDatatypeFilterExp(Conjunction con, EList<DataSourceVariable> variables){
		con.left.checkDatatypeFilterExp(variables);
		if(con.right !== null)
		{
			con.right.checkDatatypeFilterExp(variables);
			//type1.checkDatatypes(type2);
		}
		return null;
	}
	
	def dispatch DataTypes checkDatatypeFilterExp(MathTerm datatype,EList<DataSourceVariable> variables) {
		return DataTypes.NUMBER;
	}
	
	def dispatch DataTypes checkDatatypeFilterExp(BOOLEAN datatype,EList<DataSourceVariable> variables) {
		return DataTypes.BOOLIAN;
	}
	
	def dispatch DataTypes checkDatatypeFilterExp(AllTypes datatype,EList<DataSourceVariable> variables) {
		if(!datatype.id.isNullOrEmpty)
		{
			var transform = state.transforms.findFirst[it.name==datatype.id]
			if(transform !== null)
			{
				return transform.checkDatatypeFilterExp(variables);
			}
			else
			{
				var type = variables.findFirst[it.vname == datatype.id].type;
				if(type !== null)
					return type.checkDatatypeFilterExp(variables);
			}
		}
		else
		{
			return DataTypes.STRING;
		}
	}
		
	def dispatch DataTypes checkDatatypeFilterExp(Transform transform,EList<DataSourceVariable> variables) {
		var datatype = variables.findFirst[it.vname == transform.variable].type.checkDatatypeFilterExp(variables);
		if(!datatype.equals(DataTypes.NUMBER))
		{
			var datasoruce =	variables.findFirst[it.vname == transform.variable].eContainer as DataSource;
			error("Transform " + transform.name + " can not use this input. \n Only supports numbers. \n variable " + transform.variable + " is not a number in the data source " + datasoruce.name, DomainmodelPackage$Literals::FILTER__EXPRESSION);
		}
		return datatype;
	}
	
	
	def dispatch DataTypes checkDatatypeFilterExp(org.example.domainmodel.domainmodel.String datatype,EList<DataSourceVariable> variables) {
		return DataTypes.STRING;
	}
	
	
	def dispatch DataTypes checkDatatypeFilterExp(org.example.domainmodel.domainmodel.Number datatype,EList<DataSourceVariable> variables) {
		return DataTypes.NUMBER;
	}
	
	def dispatch DataTypes checkDatatypeFilterExp(org.example.domainmodel.domainmodel.Bool datatype,EList<DataSourceVariable> variables) {
		return DataTypes.BOOLIAN;
	}
	
	def Boolean isDatatypesEquals(DataTypes type1, DataTypes type2)
	{
		if(!type1.equals(type2))
		{
			warning("These date types are not the same and will always be false", DomainmodelPackage$Literals::FILTER__EXPRESSION);		 	 
			return false;
		}
		return true;
	}
	
	def dispatch checkDatatypes(LESS less, DataTypes type1, DataTypes type2)
	{
		if(type1.isDatatypesEquals(type2))
		{
			switch (type1) {
				case DataTypes.BOOLIAN: {
					boolErrorMsg("LESS")
				}
				case DataTypes.STRING: {
					stringErrorMsg("LESS");
				}
				case NUMBER: {
					//THIS IS FINE
				}
			}
		}
	}
	def dispatch checkDatatypes(MORE less, DataTypes type1, DataTypes type2)
	{
		if(type1.isDatatypesEquals(type2))
		{
			switch (type1) {
				case DataTypes.BOOLIAN: {
					boolErrorMsg("MORE")
				}
				case DataTypes.STRING: {
					stringErrorMsg("MORE");
				}
				case NUMBER: {
					//THIS IS FINE
				}
			}
		}
	}
	def dispatch checkDatatypes(EQ eq, DataTypes type1, DataTypes type2)
	{
		type1.isDatatypesEquals(type2);		
	}
	def dispatch checkDatatypes(EQLESS eqless, DataTypes type1, DataTypes type2)
	{
		if(type1.isDatatypesEquals(type2))
		{
			switch (type1) {
				case DataTypes.BOOLIAN: {
					boolErrorMsg("EQUAL or LESS")
				}
				case DataTypes.STRING: {
					stringErrorMsg("EQUAL or LESS");
				}
				case NUMBER: {
					//THIS IS FINE
				}
			}
		}
	}
	def dispatch checkDatatypes(EQMORE eqmore, DataTypes type1, DataTypes type2)
	{
		if(type1.isDatatypesEquals(type2))
		{
			switch (type1) {
				case DataTypes.BOOLIAN: {
					boolErrorMsg("EQUAL or MORE")
				}
				case DataTypes.STRING: {
					stringErrorMsg("EQUAL or MORE");
				}
				case NUMBER: {
					//THIS IS FINE
				}
			}
		}
	}
	def dispatch checkDatatypes(NOT not, DataTypes type1, DataTypes type2)
	{
		if(!type1.equals(type2))
			info("These date types are not the same and will always be true, in the not case", DomainmodelPackage$Literals::FILTER__EXPRESSION);		 	 
	}
	
	def stringErrorMsg(String type)
	{
		error("Strings can not handle operator " + type, DomainmodelPackage$Literals::FILTER__EXPRESSION);
	}
	
	def boolErrorMsg(String type)
	{
		error("Booleans can not handle operator " + type, DomainmodelPackage$Literals::FILTER__EXPRESSION);
	}
}