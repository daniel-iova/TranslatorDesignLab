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
  "rdf:li"  { return symbolFactory.newSymbol("OPEN_RDF_LI", OPEN_RDF_LI, yytext()); }
  "rdf:type" { return symbolFactory.newSymbol("OPEN_RDF_TYPE", OPEN_RDF_TYPE, yytext()); }
  
  /* Close RDF(S) Tags */
  
  "</rdf:RDF>" { return symbolFactory.newSymbol("CLOSE_RDF_RDF", CLOSE_RDF_RDF, yytext()); }
  "</rdf:Description>" { return symbolFactory.newSymbol("CLOSE_RDF_DESCRIPTION", CLOSE_RDF_DESCRIPTION, yytext()); }
  "</rdf:li>"  { return symbolFactory.newSymbol("CLOSE_RDF_LI", CLOSE_RDF_LI, yytext()); }
  "</rdf:type>" { return symbolFactory.newSymbol("CLOSE_RDF_TYPE", CLOSE_RDF_TYPE, yytext()); }
  
  /* RDF properties */
  
  "rdf:about" {return symbolFactory.newSymbol("RDF_ABOUT", RDF_ABOUT, yytext()); }
  "rdf:resource" {return symbolFactory.newSymbol("RDF_RESOURCE", RDF_RESOURCE, yytext()); }
  "rdf:ID" {return symbolFactory.newSymbol("RDF_ID", RDF_ID, yytext()); }
  
  /* MISCELLANEOUS */
  "<" { return symbolFactory.newSymbol("OPEN_TAG", OPEN_TAG, yytext()); }
  
  "/>" { return symbolFactory.newSymbol("CLOSE_SINGULAR_TAG", CLOSE_SINGULAR_TAG, yytext()); }
  
  "=" { return symbolFactory.newSymbol("EQUALS", EQUALS, yytext()); }
  {XMLVersion} { return symbolFactory.newSymbol("XML_VERSION", XML_VERSION, yytext()); }
  {TagNameWithScheme} { return symbolFactory.newSymbol("TAG_NAME_WITH_SCHEME", TAG_NAME_WITH_SCHEME, yytext()); }
  {PropertyValue} { return symbolFactory.newSymbol("PROPERTY_VALUE", PROPERTY_VALUE, yytext()); }
  /**/
  //{Quote} { return symbolFactory.newSymbol("QUOTE", QUOTE, yytext()); }
  ">" { return symbolFactory.newSymbol("CLOSE_TAG", CLOSE_TAG, yytext()); }
  "</" { return symbolFactory.newSymbol("OPEN_END_TAG", OPEN_END_TAG, yytext()); }
  {InsideText} { return symbolFactory.newSymbol("INSIDE_TEXT", INSIDE_TEXT, yytext()); }
}



// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
