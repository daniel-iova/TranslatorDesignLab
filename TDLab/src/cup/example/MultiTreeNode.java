package cup.example;


import java.util.ArrayList;

public class MultiTreeNode {
	
	private String data;
	private String extraData;
	private ArrayList<MultiTreeNode> children;
	private ArrayList<NodeProperty> properties;
	private int descendentsCount = 0; 
	
	public String getData() {
		return data;
	}
	
	public String getExtraData() {
		return extraData;
	}

	public void setData(String data) {
		this.data = data;	
	}
	
	public void setExtraData(String extraData) {
		this.extraData = extraData;
	}
	
	public int getDescendentsCount()
	{		
		return descendentsCount;
	}

	public MultiTreeNode[] getChildren() {
		MultiTreeNode[] childrenArray = new MultiTreeNode[children.size()];		
		return children.toArray(childrenArray);
	}	
	
	public MultiTreeNode(String data, String extraData)
	{
		this.data = data;
		this.extraData = extraData;
		children = new ArrayList<MultiTreeNode>();
		properties = new ArrayList<NodeProperty>();
	}
	
	public MultiTreeNode(String data) 
	{
		this(data, "");
	}
	
	public MultiTreeNode addChild(String childData)
	{
		MultiTreeNode addedNode = new MultiTreeNode(childData);
		children.add(addedNode);
		return addedNode;
	}
	
	public void addChild(MultiTreeNode node)
	{
		children.add(node);
		descendentsCount += node.descendentsCount + 1;
	}
	
	public NodeProperty addProperty(String key, String value) {
		NodeProperty prop = new NodeProperty(key, value);
		properties.add(prop);
		return prop;
	}
	
	public void addProperty(NodeProperty prop) {
		properties.add(prop);
	}
	
	public void addProperties(ArrayList<NodeProperty> props) {
		properties.addAll(props);
	}
	
	public void printNode(int level)
	{
		pad(level);
		
		System.out.print("+ " + data);
		
		if (extraData != null && extraData.length() > 0)
		{
			System.out.print(" (" + extraData + ")");
		}
		
		System.out.println("");
		
		if (!properties.isEmpty()) {
			for (NodeProperty prop : properties) {
				pad(level + 1);
				System.out.println(" -> " + prop.getKey() + " : " + prop.getValue());
			}
		}
		for (MultiTreeNode multiTreeNode : children) {
			multiTreeNode.printNode(level + 1);
		}
	}
	
	private void pad(int num) {
		for (int i = 0; i < num; i++)
		{
			System.out.print(" ");
		}
	}

}
