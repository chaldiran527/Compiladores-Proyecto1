/* JFlex example: partial Java language lexer specification */
package ParserLexer;
import java_cup.runtime.*;

/**
    * This class is a simple example lexer.
    */
%%

%class Lexer
%public 
%unicode
%cup
%line
%column

%{
    StringBuffer string = new StringBuffer();

    private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
    }
    private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
    }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
// Comment can be the last line of the file, without line terminator.
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/**" {CommentContent} "*"+ "/"
CommentContent       = ( [^*] | \*+ [^/*] )*

Identifier = [:jletter:] [:jletterdigit:]*

//DecIntegerLiteral = 0 | [1-9][0-9]*
//Entero visto en clase
//Caracter = '[a-zA-Z]' | '!\"#\$%&\'()\*\+\,\-\.\/:;<=>\?@\[\]\\\^_`{}\~�' | '[0-9]'
//Caracter = [a-zA-Z]' | '!\"#\$%&\'()\*\+\,\-\.\/:;<=>\?@\[\]\\\^_`{}\~\\´┐¢' | '[0-9]'


//DEFINIR LAS EXPRESIONES 
digito = [0-9]
digitoNoCero = [1-9]
DecIntegerLiteral = (-?{digitoNoCero} {digito}*) //No permite negativos  -?opcionalmente un no cero y pueden haber cero o mas digitos de 0-9

%state STRING

%%

/* keywords */
//Estados base cuando uno entra
//Se retornan
<YYINITIAL> "abstract"           { return symbol(sym.NAVIDAD); }
<YYINITIAL> "boolean"            { return symbol(sym.BOOLEAN); }
<YYINITIAL> "break"              { return symbol(sym.BREAK); }

<YYINITIAL> {
    /* identifiers */ 
    {Identifier}                   { return symbol(sym.IDENTIFIER); }
    
    /* literals cuando hay comilla doble entra a string*/
    {DecIntegerLiteral}            { return symbol(sym.INTEGER_LITERAL); }
    \"                             { string.setLength(0); yybegin(STRING); }

    /* operadores  */

    "="                            { return symbol(sym.EQ); }
    "=="                           { return symbol(sym.EQEQ); }
    "+"                            { return symbol(sym.PLUS); }
    "*"
    /* comments */
    {Comment}                      { /* ignore */ }
    
    /* whitespace */
    {WhiteSpace}                   { /* ignore */ }
}

<STRING> {
    \"                             { yybegin(YYINITIAL); 
                                    return symbol(sym.l_PAPANOEL, 
                                    string.toString()); }
    [^\n\r\"\\]+                   { string.append( yytext() ); }
    \\t                            { string.append('\t'); }
    \\n                            { string.append('\n'); }

    \\r                            { string.append('\r'); }
    \\\"                           { string.append('\"'); }
    \\                             { string.append('\\'); }
}

/* error fallback */
[^]                              { throw new Error("Illegal character <"+
                                                    yytext()+">"); }