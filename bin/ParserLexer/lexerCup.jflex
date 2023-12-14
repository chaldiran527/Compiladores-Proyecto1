/* JFlex example: partial Java language lexer specification */
package ParserLexer;
import java.io.StringReader;
import java_cup.runtime.*;

// ... (otras importaciones y definiciones)

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

%state ERROR

/* Reglas de recuperación en modo pánico */
<YYINITIAL,ERROR> {
    /* Caracteres no válidos */
    [^] { 
        System.err.println("Error: Carácter no reconocido en la línea " + yyline + ", columna " + yycolumn);
        yycolumn++;
        return symbol(sym.ERROR); // Puedes cambiar esto según tus necesidades
    }
}

<YYINITIAL,ERROR> "*/" {
    /* Fin de comentario no encontrado */
    System.err.println("Error: Fin de comentario no encontrado en la línea " + yyline + ", columna " + yycolumn);
    yybegin(YYINITIAL);
    return symbol(sym.ERROR); // Puedes cambiar esto según tus necesidades
}

<YYINITIAL,ERROR> [^ \t\n\r]* {
    /* Ignorar cualquier otro carácter durante la recuperación */
    yycolumn += yylength();
    return symbol(sym.ERROR); // Puedes cambiar esto según tus necesidades
}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/**" {CommentContent} "*"+ "/"
CommentContent       = ( [^*] | \*+ [^/*] )*

Identifier = [:jletter:] [:jletterdigit:]*

//DEFINIR LAS EXPRESIONES 
digito = [0-9]
digitoNoCero = [1-9]
DecIntegerLiteral = (-?{digitoNoCero} {digito}*)

%state STRING

%%

/* keywords */
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
[^]                              { 
                                    System.err.println("Error: Carácter no reconocido en la línea " + yyline + ", columna " + yycolumn);
                                    yycolumn++;
                                    return symbol(sym.ERROR); // Puedes cambiar esto según tus necesidades
                                }
