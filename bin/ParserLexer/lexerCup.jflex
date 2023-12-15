/* JFlex example: partial Java language lexer specification */
package ParserLexer;
import java.io.StringReader;
import java_cup.runtime.*;

/* Options and declarations */
%%

%class Lexer
%public 
%unicode
%cup
%line
%column

%{
    StringBuffer string = new StringBuffer();
    private int errorCount = 0;

    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }

    // Método para manejar errores y recuperación
    private void handleError(String message) {
        System.err.println("Error: " + message + " en la línea " + yyline + ", columna " + yycolumn);
        errorCount++;
        // Puedes agregar más lógica de recuperación aquí si es necesario
        // Por ejemplo, puedes avanzar al siguiente ';' o '}' si el error ocurre dentro de una expresión o bloque.
        // También puedes ignorar caracteres hasta encontrar un punto seguro para continuar.
    }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* commentarios */
Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

TraditionalComment   = "/\_" [^\_] ~"\_/" | "/\_" "\_"+ "/"
EndOfLineComment     = "@" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/**" {CommentContent} "*"+ "/"
CommentContent       =  ([^\_] | \_+ [^/\_])*

Identifier = [:jletter:] [:jletterdigit:]*

//DEFINIR LAS EXPRESIONES 
digito = [0-9]
digitoNoCero = [1-9]
DecIntegerLiteral = (-?{digitoNoCero} {digito}*)

Float = -? (0 | {digitoNoCero} {digito}*) ("." {digito}+)? (("e" | "E") -? {digito}+)?

Delimiter = \|

OpenParenthesis = \(
CloseParenthesis = \(
OpenBrackets = \[
CloseBrackets =\]
OpenBraces = \{
CloseBraces =\}
Assignment = \<\=

Not = \!
And =  \^
Or = \#

//Operadores Aritmeticos

Decrement = \-\-
Increment = \+\+
Addition = \+
Substraction = \- 
DivisionFloat = \/
DivisionInteger = \/\/
Power = \*\*
Product = \*
Mod = \~

Comma = \,
Character = \' {InputCharacter} \'

/* Lexical rules */
%state STRING
%state ERROR

%%


/* keywords */
<YYINITIAL> "abstract"           { return symbol(sym.NAVIDAD); }
<YYINITIAL> "boolean"            { return symbol(sym.BOOLEAN); }
<YYINITIAL> "break"              { return symbol(sym.BREAK); }


<YYINITIAL> {

    // Identificadores
    {Decrement}                           { return symbol(sym.QUIEN); }
    
    {Identifier}                   { return symbol(sym.IDENTIFIER); }
//    \"                             { string.setLength(0); yybegin(STRING);  }

    // Comentarios
    {Comment}                      { /* ignore */ }
    \"                             {string.setLength(0); yybegin(STRING); }



    // Operadores y otros tokens
    "="                            { return symbol(sym.EQ); }
    "=="                           { return symbol(sym.e_jinglebell); }
    "+"                            { return symbol(sym.PLUS); }
    "!="                           { return symbol(sym.ne_tinseltoes); }
    "<"                            { return symbol(sym.l_slinky); }
    ">"                            { return symbol(sym.g_merryberry); }
    ">="                           { return symbol(sym.ge_snowflake); }
    "<="                           { return symbol(sym.le_candycane); }


    {DecIntegerLiteral}            { return symbol(sym.INTEGER_LITERAL); }

    {Float}                        { return symbol(sym.l_float_santa);}
    {Character}                    { return symbol(sym.REGALO);} 

    // Espacios en blanco
    {WhiteSpace}                   { /* ignore */ }

    // Cualquier otro carácter no reconocido
    .                              { handleError("Carácter no reconocido"); }
}

<STRING> {
    \"                             { yybegin(YYINITIAL); 
                                    return symbol(sym.l_PAPANOEL, 
                                    ("\"" + string.toString() + "\"")); }

    [^\n\r\"\\]                   { string.append( yytext() ); }
    \\t                            { string.append('\t'); }
    \\n                            { string.append('\n'); }

    \\r                            { string.append('\r'); }
    \\\"                           { string.append('\"'); }
    \\                             { string.append('\\'); }  
    
    // Cualquier otro carácter no reconocido en el estado STRING
    .                              { handleError("Carácter no reconocido en la cadena"); }
}

/* Reglas de recuperación en modo pánico */
<YYINITIAL,ERROR> {
    // Caracteres no válidos, se intenta avanzar al siguiente caracter reconocible
    [^] { 
        yycolumn++;
        return symbol(sym.ERROR);
    }
}

<YYINITIAL,ERROR> "*/" {
    // Fin de comentario no encontrado, se intenta recuperar
    yybegin(YYINITIAL);
    yycolumn += 2; // Avanzar dos caracteres para evitar un bucle infinito
    return symbol(sym.ERROR);
}

<YYINITIAL,ERROR> [^ \t\n\r]* {
    // Ignorar cualquier otro carácter durante la recuperación
    yycolumn += yylength();
    return symbol(sym.ERROR);
}


/* error fallback */
[^]                              { 
                                    handleError("Carácter no reconocido");
                                    yycolumn++;
                                    return symbol(sym.ERROR);
                                }
