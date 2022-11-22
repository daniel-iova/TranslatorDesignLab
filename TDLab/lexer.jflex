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
%caseless
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
Quote = \"
InsideText=>.+<\/?
PropertyValue=\".*\"
XMLVersion = "<?xml version="\"[0-9]\.[0-9]\""?>"

%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

<YYINITIAL> {

  {Whitespace} {}
  
  /* Open RDF(S) Tags */
  
  "rdf:RDF" { return symbolFactory.newSymbol("OPEN_RDF_RDF", OPEN_RDF_RDF, yytext()); }
  "rdf:Description" { return symbolFactory.newSymbol("OPEN_RDF_DESCRIPTION", OPEN_RDF_DESCRIPTION, yytext()); }
  "rdfs:Resource" { return symbolFactory.newSymbol("OPEN_RDFS_RESOURCE", OPEN_RDFS_RESOURCE, yytext()); }
  "rdfs:Class" { return symbolFactory.newSymbol("OPEN_RDFS_CLASS", OPEN_RDFS_CLASS, yytext()); }
  "rdfs:Literal" { return symbolFactory.newSymbol("OPEN_RDFS_LITERAL", OPEN_RDFS_LITERAL, yytext()); }
  "rdf:Bag" { return symbolFactory.newSymbol("OPEN_RDF_BAG", OPEN_RDF_BAG, yytext()); }
  "rdf:Seq" { return symbolFactory.newSymbol("OPEN_RDF_SEQ", OPEN_RDF_SEQ, yytext()); }
  "rdf:Alt" { return symbolFactory.newSymbol("OPEN_RDF_ALT", OPEN_RDF_ALT, yytext()); }
  "rdf:li"  { return symbolFactory.newSymbol("OPEN_RDF_LI", OPEN_RDF_LI, yytext()); }
  "rdf:langString" { return symbolFactory.newSymbol("OPEN_RDF_LANGSTRING", OPEN_RDF_LANGSTRING, yytext()); }
  "rdf:HTML" {return symbolFactory.newSymbol("OPEN_RDF_HTML", OPEN_RDF_HTML, yytext()); }
  "rdf:List" {return symbolFactory.newSymbol("OPEN_RDF_LIST", OPEN_RDF_LIST, yytext()); }
  "rdf:Statement" {return symbolFactory.newSymbol("OPEN_RDF_STATEMENT", OPEN_RDF_STATEMENT, yytext()); }
  "rdfs:Datatype" {return symbolFactory.newSymbol("OPEN_RDF_DATATYPE", OPEN_RDF_DATATYPE, yytext()); }
  "rdfs:Container" {return symbolFactory.newSymbol("OPEN_RDF_CONTAINER", OPEN_RDF_CONTAINER, yytext()); }
  "rdf:type" { return symbolFactory.newSymbol("OPEN_RDF_TYPE", OPEN_RDF_TYPE, yytext()); }
  "rdf:aboutEach" { return symbolFactory.newSymbol("RDF_ABOUTEACH", RDF_ABOUTEACH, yytext()); }
  "rdf:aboutEachPrefix" { return symbolFactory.newSymbol("RDF_ABOUTEACHPREFIX", RDF_ABOUTEACHPREFIX, yytext()); }
  "rdf:bagID" { return symbolFactory.newSymbol("RDF_BAGID", RDF_BAGID, yytext()); }
  
  /* Close RDF(S) Tags */
  
  "</rdf:RDF>" { return symbolFactory.newSymbol("CLOSE_RDF_RDF", CLOSE_RDF_RDF, yytext()); }
  "</rdf:Description>" { return symbolFactory.newSymbol("CLOSE_RDF_DESCRIPTION", CLOSE_RDF_DESCRIPTION, yytext()); }
  "</rdfs:Resource>" { return symbolFactory.newSymbol("CLOSE_RDFS_RESOURCE", CLOSE_RDFS_RESOURCE, yytext()); }
  "</rdfs:Class>" { return symbolFactory.newSymbol("CLOSE_RDFS_CLASS", CLOSE_RDFS_CLASS, yytext()); }
  "</rdfs:Literal>" { return symbolFactory.newSymbol("CLOSE_RDFS_LITERAL", CLOSE_RDFS_LITERAL, yytext()); }
  "</rdf:Bag>" { return symbolFactory.newSymbol("CLOSE_RDF_BAG", CLOSE_RDF_BAG, yytext()); }
  "</rdf:Seq>" { return symbolFactory.newSymbol("CLOSE_RDF_SEQ", CLOSE_RDF_SEQ, yytext()); }
  "</rdf:Alt>" { return symbolFactory.newSymbol("CLOSE_RDF_ALT", CLOSE_RDF_ALT, yytext()); }
  "</rdf:li>"  { return symbolFactory.newSymbol("CLOSE_RDF_LI", CLOSE_RDF_LI, yytext()); }
  "</rdf:langString>" { return symbolFactory.newSymbol("CLOSE_RDF_LANGSTRING", CLOSE_RDF_LANGSTRING, yytext()); }
  "</rdf:HTML>" {return symbolFactory.newSymbol("CLOSE_RDF_HTML", CLOSE_RDF_HTML, yytext()); }
  "</rdf:List>" {return symbolFactory.newSymbol("CLOSE_RDF_LIST", CLOSE_RDF_LIST, yytext()); }
  "</rdf:Statement>" {return symbolFactory.newSymbol("CLOSE_RDF_STATEMENT", CLOSE_RDF_STATEMENT, yytext()); }
  "</rdfs:Datatype>" {return symbolFactory.newSymbol("CLOSE_RDF_DATATYPE", CLOSE_RDF_DATATYPE, yytext()); }
  "</rdfs:Container>" {return symbolFactory.newSymbol("CLOSE_RDF_CONTAINER", CLOSE_RDF_CONTAINER, yytext()); }
  "</rdf:type>" { return symbolFactory.newSymbol("CLOSE_RDF_TYPE", CLOSE_RDF_TYPE, yytext()); }
  
  /* RDF properties */
  
  "rdfs:range" { return symbolFactory.newSymbol("RDFS_RANGE", RDFS_RANGE, yytext()); }
  "rdfs:domain" { return symbolFactory.newSymbol("RDFS_DOMAIN", RDFS_DOMAIN, yytext()); }
  "rdfs:subClassOf" { return symbolFactory.newSymbol("RDFS_SUBCLASSOF", RDFS_SUBCLASSOF, yytext()); }      
  "rdfs:subPropertyOf" { return symbolFactory.newSymbol("RDFS_SUBPROPERTYOF", RDFS_SUBPROPERTYOF, yytext()); }
  "rdfs:label" { return symbolFactory.newSymbol("RDFS_LABEL", RDFS_LABEL, yytext()); }
  "rdfs:comment" { return symbolFactory.newSymbol("RDFS_COMMENT", RDFS_COMMENT, yytext()); }
  "rdf:about" {return symbolFactory.newSymbol("RDF_ABOUT", RDF_ABOUT, yytext()); }
  "rdf:resource" {return symbolFactory.newSymbol("RDF_RESOURCE", RDF_RESOURCE, yytext()); }
  "rdf:parseType=\"Literal\"" {return symbolFactory.newSymbol("RDF_PARSETYPE", RDF_PARSETYPE_LITERAL, yytext()); }
  "rdf:parseType=\"Resource\"" {return symbolFactory.newSymbol("RDF_PARSETYPE", RDF_PARSETYPE_RESOURCE, yytext()); }
  "rdf:parseType=\"Collection\"" {return symbolFactory.newSymbol("RDF_PARSETYPE", RDF_PARSETYPE_COLLECTION, yytext()); }
  "rdf:parseType" {return symbolFactory.newSymbol("RDF_PARSETYPE", RDF_PARSETYPE, yytext()); }
  "rdf:datatype" {return symbolFactory.newSymbol("RDF_DATATYPE", RDF_DATATYPE, yytext()); }
  "rdf:nodeID" {return symbolFactory.newSymbol("RDF_NODEID", RDF_NODEID, yytext()); }
  "rdf:ID" {return symbolFactory.newSymbol("RDF_ID", RDF_ID, yytext()); }
  {Rdf_N} {return symbolFactory.newSymbol("RDF_N", RDF_N, yytext()); }
  "rdf:subject" { return symbolFactory.newSymbol("RDF_SUBJECT", RDF_SUBJECT, yytext()); }
  "rdf:predicate" { return symbolFactory.newSymbol("RDF_PREDICATE", RDF_PREDICATE, yytext()); }      
  "rdf:object" { return symbolFactory.newSymbol("RDF_OBJECT", RDF_OBJECT, yytext()); }
  "rdfs:seeAlso" { return symbolFactory.newSymbol("RDFS_SEEALSO", RDFS_SEEALSO, yytext()); }        
  "rdfs:isDefinedBy" { return symbolFactory.newSymbol("RDFS_ISDEFINEDBY", RDFS_ISDEFINEDBY, yytext()); }
  "rdf:value" { return symbolFactory.newSymbol("RDF_VALUE", RDF_VALUE, yytext()); }
  
  /* MISCELLANEOUS */
  "<" { return symbolFactory.newSymbol("OPEN_TAG", OPEN_TAG, yytext()); }
  
  "/>" { return symbolFactory.newSymbol("CLOSE_SINGULAR_TAG", CLOSE_SINGULAR_TAG, yytext()); }
  
  "=" { return symbolFactory.newSymbol("EQUALS", EQUALS, yytext()); }
  {XMLVersion} { return symbolFactory.newSymbol("XML_VERSION", XML_VERSION, yytext()); }
  {TagNameWithScheme} { return symbolFactory.newSymbol("TAG_NAME_WITH_SCHEME", TAG_NAME_WITH_SCHEME, yytext()); }
  {PropertyValue} { return symbolFactory.newSymbol("PROPERTY_VALUE", PROPERTY_VALUE, yytext()); }
  /**/
  {Quote} { return symbolFactory.newSymbol("QUOTE", QUOTE, yytext()); }
  ">" { return symbolFactory.newSymbol("CLOSE_TAG", CLOSE_TAG, yytext()); }
  "</" { return symbolFactory.newSymbol("OPEN_END_TAG", OPEN_END_TAG, yytext()); }
  {InsideText} { return symbolFactory.newSymbol("INSIDE_TEXT", INSIDE_TEXT, yytext()); }
}



// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
