/* JFlex example: partial Java language lexer specification */
package ParserLexer;
import java.io.StringReader;
import java_cup.runtime.*;

%class Lexer
%public 
%unicode
%cup
%line
%column

%{
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

%state ERROR

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
    // Identificadores
    {Identifier}                   { return symbol(sym.IDENTIFIER); }
    
    // Literales cuando hay comillas dobles, entra al estado STRING
    {DecIntegerLiteral}            { return symbol(sym.INTEGER_LITERAL); }
    \"                             { yybegin(STRING); }

    // Operadores y otros tokens
    "="                            { return symbol(sym.EQ); }
    "=="                           { return symbol(sym.EQEQ); }
    "+"                            { return symbol(sym.PLUS); }
    
    // Comentarios
    {Comment}                      { /* ignore */ }

    // Espacios en blanco
    {WhiteSpace}                   { /* ignore */ }

    // Cualquier otro carácter no reconocido
    .                              { handleError("Carácter no reconocido"); }
}

<STRING> {
    // Literal de cadena cerrado correctamente
    \"                             { yybegin(YYINITIAL); 
                                    return symbol(sym.l_PAPANOEL, 
                                    yytext().toString()); }
    
    // Contenido de cadena
    [^\n\r\"\\]+                   { /* puedes manejar contenido de cadena si es necesario */ }
    
    // Caracteres de escape
    \\t                            { /* manejar tabulación si es necesario */ }
    \\n                            { /* manejar nueva línea si es necesario */ }
    \\r                            { /* manejar retorno de carro si es necesario */ }
    \\\"                           { /* manejar comilla doble si es necesario */ }
    \\                             { /* manejar barra invertida si es necesario */ }
    
    // Cualquier otro carácter no reconocido en el estado STRING
    .                              { handleError("Carácter no reconocido en la cadena"); }
}

/* error fallback */
[^]                              { 
                                    handleError("Carácter no reconocido");
                                    yycolumn++;
                                    return symbol(sym.ERROR);
                                }
