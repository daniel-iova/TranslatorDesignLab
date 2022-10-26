package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%

%class Lexer
%implements sym
%public
%unicode
%line
%column
%cup
%char
%{
	

    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

Newline    = \r | \n | \r\n
Whitespace = [ \t\f] | {Newline}
Comments = "<!--" [^*] ~"-->"


TagNameWithScheme = [a-zA-z0-9\-_]+:[a-zA-z0-9\-_]+
Rdf_N = "rdf_"[0-9]+
PropertyValue=\".*\"

%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

<YYINITIAL> {

  {Whitespace} {}
  
  "<" { return symbolFactory.newSymbol("OPEN_TAG", OPEN_TAG); }
  "</" { return symbolFactory.newSymbol("OPEN_END_TAG", OPEN_END_TAG); }
  ">" { return symbolFactory.newSymbol("CLOSE_TAG", CLOSE_TAG); }
  "=" { return symbolFactory.newSymbol("EQUALS", EQUALS); }
  {TagNameWithScheme} { return symbolFactory.newSymbol("TAG_NAME_WITH_SCHEME", TAG_NAME_WITH_SCHEME); }
  {PropertyValue} { return symbolFactory.newSymbol("PROPERTY_VALUE", PROPERTY_VALUE, yytext()); }
  
  /* Open RDF(S) Tags */
  
  "<rdf:RDF" { return symbolFactory.newSymbol("OPEN_RDF_RDF", OPEN_RDF_RDF); }
  "<rdf:Description" { return symbolFactory.newSymbol("OPEN_RDF_DESCRIPTION", OPEN_RDF_DESCRIPTION); }
  "<rdfs:Resource" { return symbolFactory.newSymbol("OPEN_RDFS_RESOURCE", OPEN_RDFS_RESOURCE); }
  "<rdfs:Class" { return symbolFactory.newSymbol("OPEN_RDFS_CLASS", OPEN_RDFS_CLASS); }
  "<rdfs:Literal" { return symbolFactory.newSymbol("OPEN_RDFS_LITERAL", OPEN_RDFS_LITERAL); }
  "<rdf:Bag" { return symbolFactory.newSymbol("OPEN_RDF_BAG", OPEN_RDF_BAG); }
  "<rdf:Seq" { return symbolFactory.newSymbol("OPEN_RDF_SEQ", OPEN_RDF_SEQ); }
  "<rdf:Alt" { return symbolFactory.newSymbol("OPEN_RDF_ALT", OPEN_RDF_ALT); }
  "<rdf:li"  { return symbolFactory.newSymbol("OPEN_RDF_LI", OPEN_RDF_LI); }
  "<rdf:langString" { return symbolFactory.newSymbol("OPEN_RDF_LANGSTRING", OPEN_RDF_LANGSTRING); }
  "<rdf:HTML" {return symbolFactory.newSymbol("OPEN_RDF_HTML", OPEN_RDF_HTML); }
  "<rdf:List" {return symbolFactory.newSymbol("OPEN_RDF_LIST", OPEN_RDF_LIST); }
  "<rdf:Statement" {return symbolFactory.newSymbol("OPEN_RDF_STATEMENT", OPEN_RDF_STATEMENT); }
  "<rdfs:Datatype" {return symbolFactory.newSymbol("OPEN_RDF_DATATYPE", OPEN_RDF_DATATYPE); }
  "<rdfs:Container" {return symbolFactory.newSymbol("OPEN_RDF_CONTAINER", OPEN_RDF_CONTAINER); }
  
  /* Close RDF(S) Tags */
  
  "</rdf:RDF>" { return symbolFactory.newSymbol("CLOSE_RDF_RDF", CLOSE_RDF_RDF); }
  "</rdf:Description>" { return symbolFactory.newSymbol("CLOSE_RDF_DESCRIPTION", CLOSE_RDF_DESCRIPTION); }
  "</rdfs:Resource>" { return symbolFactory.newSymbol("CLOSE_RDFS_RESOURCE", CLOSE_RDFS_RESOURCE); }
  "</rdfs:Class>" { return symbolFactory.newSymbol("CLOSE_RDFS_CLASS", CLOSE_RDFS_CLASS); }
  "</rdfs:Literal>" { return symbolFactory.newSymbol("CLOSE_RDFS_LITERAL", CLOSE_RDFS_LITERAL); }
  "</rdf:Bag>" { return symbolFactory.newSymbol("CLOSE_RDF_BAG", CLOSE_RDF_BAG); }
  "</rdf:Seq>" { return symbolFactory.newSymbol("CLOSE_RDF_SEQ", CLOSE_RDF_SEQ); }
  "</rdf:Alt>" { return symbolFactory.newSymbol("CLOSE_RDF_ALT", CLOSE_RDF_ALT); }
  "</rdf:li>"  { return symbolFactory.newSymbol("CLOSE_RDF_LI", CLOSE_RDF_LI); }
  "</rdf:langString>" { return symbolFactory.newSymbol("CLOSE_RDF_LANGSTRING", CLOSE_RDF_LANGSTRING); }
  "</rdf:HTML>" {return symbolFactory.newSymbol("CLOSE_RDF_HTML", CLOSE_RDF_HTML); }
  "</rdf:List>" {return symbolFactory.newSymbol("CLOSE_RDF_LIST", CLOSE_RDF_LIST); }
  "</rdf:Statement>" {return symbolFactory.newSymbol("CLOSE_RDF_STATEMENT", CLOSE_RDF_STATEMENT); }
  "</rdfs:Datatype>" {return symbolFactory.newSymbol("CLOSE_RDF_DATATYPE", CLOSE_RDF_DATATYPE); }
  "</rdfs:Container>" {return symbolFactory.newSymbol("CLOSE_RDF_CONTAINER", CLOSE_RDF_CONTAINER); }
  
  /* RDF properties */
  
  "rdfs:range=" { return symbolFactory.newSymbol("RDFS_RANGE", RDFS_RANGE); }
  "rdfs:domain=" { return symbolFactory.newSymbol("RDFS_DOMAIN", RDFS_DOMAIN); }
  "rdf:type=" { return symbolFactory.newSymbol("RDF_TYPE", RDF_TYPE); }
  "rdfs:subClassOf=" { return symbolFactory.newSymbol("RDFS_SUBCLASSOF", RDFS_SUBCLASSOF); }      
  "rdfs:subPropertyOf=" { return symbolFactory.newSymbol("RDFS_SUBPROPERTYOF", RDFS_SUBPROPERTYOF); }
  "rdfs:label=" { return symbolFactory.newSymbol("RDFS_LABEL", RDFS_LABEL); }
  "rdfs:comment=" { return symbolFactory.newSymbol("RDFS_COMMENT", RDFS_COMMENT); }
  "rdf:about=" {return symbolFactory.newSymbol("RDF_ABOUT", RDF_ABOUT); }
  "rdf:resource=" {return symbolFactory.newSymbol("RDF_RESOURCE", RDF_RESOURCE); }
  "rdf:parseType=" {return symbolFactory.newSymbol("RDF_PARSETYPE", RDF_PARSETYPE); }
  "rdf:datatype=" {return symbolFactory.newSymbol("RDF_DATATYPE", RDF_DATATYPE); }
  "rdf:nodeID=" {return symbolFactory.newSymbol("RDF_NODEID", RDF_NODEID); }
  "rdf:ID=" {return symbolFactory.newSymbol("RDF_ID", RDF_ID); }
  {Rdf_N} {return symbolFactory.newSymbol("RDF_N", RDF_N); }
  "rdf:subject=" { return symbolFactory.newSymbol("RDF_SUBJECT", RDF_SUBJECT); }
  "rdf:predicate=" { return symbolFactory.newSymbol("RDF_PREDICATE", RDF_PREDICATE); }      
  "rdf:object=" { return symbolFactory.newSymbol("RDF_OBJECT", RDF_OBJECT); }
  "rdfs:seeAlso=" { return symbolFactory.newSymbol("RDFS_SEEALSO", RDFS_SEEALSO); }        
  "rdfs:isDefinedBy=" { return symbolFactory.newSymbol("RDFS_ISDEFINEDBY", RDFS_ISDEFINEDBY); }
  "rdf:value=" { return symbolFactory.newSymbol("RDF_VALUE", RDF_VALUE); }
}



// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
