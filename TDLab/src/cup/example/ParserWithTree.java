package cup.example;

import java.util.ArrayList;

public class ParserWithTree extends Parser{

	public ParserWithTree() 
	{
		super();
	}
	
	protected MultiTreeNode createRDFRootTag(String name, ArrayList<NodeProperty> nodeElementAttrList, MultiTreeNode nodeElementList, MultiTreeNode rpEltEnd) 
	{ 
		MultiTreeNode newNode = new MultiTreeNode(name);
 		if (nodeElementAttrList != null) {
 			newNode.addProperties(nodeElementAttrList);
 		}
 		if (nodeElementList != null) { 			
 			newNode.addChild(nodeElementList);
 		}
 		if (rpEltEnd != null) {
 			newNode.setExtraData(rpEltEnd.getExtraData());
 		}
 		return newNode; 
	}
	
	protected MultiTreeNode	createNodeElementNode(String name, ArrayList<NodeProperty> nodeElementAttrList, MultiTreeNode propertyEltList, MultiTreeNode endInfo) 
	{ 
		MultiTreeNode newNode = new MultiTreeNode(name);
		if (nodeElementAttrList != null) { 			
			newNode.addProperties(nodeElementAttrList);
 		}
		if (propertyEltList != null) { 			
 			newNode.addChild(propertyEltList);
 		}
		if (endInfo != null) { 			
			newNode.addChild(endInfo);
 		}
 		return newNode; 
	}
	
	protected NodeProperty createNodeElementAttr(String name, String insideText)
	{ 
		return new NodeProperty(name, insideText);
	}
	
	protected MultiTreeNode createRPEltEndNode(MultiTreeNode nodeElement, String insideText)
	{ 
		MultiTreeNode insideTextNode = null;
		if (insideText != null) {
			insideTextNode = new MultiTreeNode("Inside Text", getInsideText(insideText));
		}
		
		if (nodeElement != null) {
			if (insideTextNode != null) {
				nodeElement.setExtraData(getInsideText(insideText));
			}
			return nodeElement;
		}
 		return insideTextNode;
	}
	
	protected MultiTreeNode createGenericTagNode(String name, String insideText)
	{ 
		MultiTreeNode newNode = new MultiTreeNode(name, getInsideText(insideText));
 		return newNode; 
	}
	
	protected MultiTreeNode createResourcePropertyEltNode(String name, ArrayList<NodeProperty> nodeElementAttrList, MultiTreeNode rpEltEnd) 
	{ 
		MultiTreeNode newNode = new MultiTreeNode(name);
 		if (nodeElementAttrList != null) { 			
 			newNode.addProperties(nodeElementAttrList);
 		}
 		if (rpEltEnd != null) {
 			if (rpEltEnd.getData() == "Inside Text") {
 				newNode.setExtraData(rpEltEnd.getExtraData());
 			}
 			else {
 				newNode.setExtraData(rpEltEnd.getExtraData());
 				rpEltEnd.setExtraData(null);
 				newNode.addChild(rpEltEnd);
 			}
 		} 		
 		return newNode; 
	}
	
	private String getInsideText(String insideText) {
		String res = insideText;
		if (res.charAt(0) == '"') {
			return res.substring(1, res.length()-1);
		}
		if (res.charAt(0) == '>') {
			return res.substring(1, res.length()-2);
		}
		return res;
	}
}
