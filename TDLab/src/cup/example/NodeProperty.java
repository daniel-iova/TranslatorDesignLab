package cup.example;

public class NodeProperty {
	private String key;
	private String value;
	
	public NodeProperty(String key, String value) {
		setKey(key);
		setValue(value);
	}
	
	public String getKey() {
		return key;
	}
	
	public String getValue() {
		return value;
	}
	
	public void setKey(String key) {
		this.key = key;
	}
	
	public void setValue(String value) {
		this.value = value;
	}
}
