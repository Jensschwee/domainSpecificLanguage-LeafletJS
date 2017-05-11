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
		di.right.findFilterVariables(variabels);
	}
	
	def dispatch void findFilterVariables(Conjunction con, Set<String> variabels){
		con.left.findFilterVariables(variabels);
		con.right.findFilterVariables(variabels);
	}
	
	def dispatch void findFilterVariables(LogicExp le, Set<String> variabels){
		le.left.findFilterVariables(variabels);
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
		con.right.findFilterVariables(variabels);
	}
	
	@Check
	def checkFilterDatasoruces(Filter filter) {
		if(filter.expression != null )
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
	
	@Check
	def checkDataTypesForFilter(Filter filter) {
		var layer =	filter.eContainer() as Layer;
		filter.expression.checkDatatypeExp(layer.datasource.variables);
	}
	
	def void checkDatatypeExp(LogicExpression exp,EList<DataSourceVariable> variables) {
		exp.checkDatatypeFilterExp(variables);
	}
	
	def dispatch Object checkDatatypeFilterExp(LogicExp exp,EList<DataSourceVariable> variables) {
		var type1 =	exp.left.checkDatatypeFilterExp(variables);
		var type2 = exp.right.checkDatatypeFilterExp(variables);
		type1.checkDatatypes(type2);
		System.out.println("fisk");
		return null;
	}
	
	def dispatch Object checkDatatypeFilterExp(Comparison com, EList<DataSourceVariable> variables){
		var type1 =	com.left.checkDatatypeFilterExp(variables);
		var type2 = com.right.checkDatatypeFilterExp(variables);
		type1.checkDatatypes(type2);
		return null;
	}
	
	def dispatch Object checkDatatypeFilterExp(Disjunction di, EList<DataSourceVariable> variables){
		var type1 =	di.left.checkDatatypeFilterExp(variables);
		var type2 = di.right.checkDatatypeFilterExp(variables);
		type1.checkDatatypes(type2);
				return null;
	}
	
	def dispatch Object checkDatatypeFilterExp(Conjunction con, EList<DataSourceVariable> variables){
		var type1 =	con.left.checkDatatypeFilterExp(variables);
		var type2 = con.right.checkDatatypeFilterExp(variables);
		type1.checkDatatypes(type2);
						return null;
	}
	
	def dispatch Object checkDatatypeFilterExp(MathTerm datatype,EList<DataSourceVariable> variables) {
		new Integer(0);
	}
	
	def dispatch Object checkDatatypeFilterExp(BOOLEAN datatype,EList<DataSourceVariable> variables) {
		return new Boolean(true);
	}
	
	def dispatch Object checkDatatypeFilterExp(AllTypes datatype,EList<DataSourceVariable> variables) {
		if(!datatype.id.isEmpty)
		{
			var transform = state.transforms.findFirst[it.name==datatype.id]
			if(transform !== null)
			{
				return transform.checkDatatypeFilterExp(variables);
			}
			else
				return variables.findFirst[it.vname == datatype.id].type.checkDatatypeFilterExp(variables);
		}
		else if (!datatype.string.isEmpty)
		{
			return new String();
		}
	}
		
	def dispatch Object checkDatatypeFilterExp(Transform transform,EList<DataSourceVariable> variables) {
		return variables.findFirst[it.vname == transform.variable].type.checkDatatypeFilterExp(variables);
	}
	
	
	def dispatch Object checkDatatypeFilterExp(org.example.domainmodel.domainmodel.String datatype,EList<DataSourceVariable> variables) {
		return new String();
	}
	
	
	def dispatch Object checkDatatypeFilterExp(org.example.domainmodel.domainmodel.Number datatype,EList<DataSourceVariable> variables) {
		return new Integer(0);
	}
	
	def dispatch Object checkDatatypeFilterExp(org.example.domainmodel.domainmodel.Bool datatype,EList<DataSourceVariable> variables) {
		return new Boolean(true);
	}
	
	def checkDatatypes(Object type1, Object type2)
	{
		if(!type1.equals(type2))
		{
			warning("These date types are not the same and will always be false", DomainmodelPackage$Literals::FILTER__EXPRESSION);		 	 
		}
	}
}