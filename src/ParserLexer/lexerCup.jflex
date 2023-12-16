/* https://www.jflex.de/manual.html */
/* JFlex example: partial Java language lexer specification */
package ParserLexer;
import java.io.StringReader;
import java_cup.runtime.*;

/*Declaraciones y opciones*/
%%

%class Lexer
%public 
%unicode
%cup
%line
%column

%{
    //Variable string para imprimir los contenidos de los tokens encontrados
    StringBuffer string = new StringBuffer();
    private int errorCount = 0;

    //Definicion de symbol predefinidos por el ejemplo proporcionado por jflex
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }

    //Método para manejar errores y recuperación
    private void handleError(String message) {
        System.err.println("Error: " + message + " en la línea " + yyline + ", columna " + yycolumn);
        errorCount++;
    }
%}

//Se definen las expresiones para espacios en blanco, caracteres y finalizadores de linea
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* Se definen las expresiones para commentarios */
Comment = {TraditionalComment} | {EndOfLineComment}

TraditionalComment   = "/\_" [^\_] ~"\_/" | "/\_" "\_"+ "/"
TraditionalCommentError = "/_" [^\_]* 
EndOfLineComment     = "@" {InputCharacter}* {LineTerminator}?
CommentContent       =  ([^\_] | \_+ [^/\_])*

//Se define el regex del identificador 
Identifier = [:jletter:] [:jletterdigit:]*

//SE DEFINEN LAS EXPRESIONES NUMERICAS
digito = [0-9]
digitoNoCero = [1-9]
DecIntegerLiteral =  0 | -?[1-9]{digito}* 
Float = -? (0 | {digitoNoCero} {digito}*) ("." {digito}+)? (("e" | "E") -? {digito}+)?

//Operadores de asignacion, booleanos y finalizacion
Delimiter = \|
Assignment = \<\=
Not = \!
And =  \^
Or = \#

//Operadores Aritmeticos unarios y binarios
Decrement = \-\-
Increment = \+\+
Addition = \+
Substraction = \- 
DivisionFloat = \/
DivisionInteger = \/\/
Power = \*\*
Product = \*
Mod = \~

//Coma y caracter
Comma = \,
Character = \' {InputCharacter} \'

/* Reglas y estados lexicos */
%state STRING
%state ERROR
%state DECREMENT

%%


/* Palabras reservadas */
<YYINITIAL> "abstract"           { return symbol(sym.NAVIDAD); }
<YYINITIAL> "if"                 { return symbol(sym.ELFO); }
<YYINITIAL> "elif"               { return symbol(sym.HADA); }
<YYINITIAL> "else"               { return symbol(sym.DUENDE); }
<YYINITIAL> "for"                { return symbol(sym.ENVUELVE); }
<YYINITIAL> "while"              { return symbol(sym.ESPERARASANTA); }
<YYINITIAL> "do"                 { return symbol(sym.HACE); }
<YYINITIAL> "until"              { return symbol(sym.REVISA); }
<YYINITIAL> "switch"             { return symbol(sym.TRINEO); }
<YYINITIAL> "return"             { return symbol(sym.ENVIA); }
<YYINITIAL> "break"              { return symbol(sym.CORTA); }
<YYINITIAL> "print"              { return symbol(sym.NARRA); }
<YYINITIAL> "read"               { return symbol(sym.ESCUCHA); }
<YYINITIAL> "float"              { return symbol(sym.t_float_santa); }
<YYINITIAL> "boolean"            { return symbol(sym.t_bool_colacho); }
<YYINITIAL> "str"                { return symbol(sym.t_string_nicolas); }
<YYINITIAL> "char"               { return symbol(sym.t_char_nick); }
<YYINITIAL> "arr"                { return symbol(sym.t_arr_noel); }
<YYINITIAL> "int"                { return symbol(sym.t_int_sinterklass); }



<YYINITIAL> {
   // Espacios en blanco no se retornan
    {WhiteSpace}                   { /* ignore */ }

    // Comentarios no se retorna
    {Comment}                      { /* ignore */ }
    \"                             {string.setLength(0); yybegin(STRING); }

    //Comentario multilinea sin finalizacion "_/" que se retorna por ser error
    {TraditionalCommentError}      { return symbol(sym.ERROR);}
    \"                             {string.setLength(0); yybegin(STRING); }

    //Se evalua retornan los tipos de parentesis
    "("                            { return symbol(sym.ABRECUENTO); }
    ")"                            { return symbol(sym.CIERRECUENTO); }
    "["                            { return symbol(sym.ABREEMPAQUE); }
    "]"                            { return symbol(sym.CIERRAEMPAQUE); }
    "{"                            { return symbol(sym.ABREREGALO); }
    "}"                            { return symbol(sym.CIERRAREGALO); }



    //Operadores aritmeticos unarios  
    {Decrement}                    { return symbol(sym.QUIEN); }   
    {Increment}                    { return symbol(sym.GRINCH); } 


    //Operadores booleanos 
    {And}                     { return symbol(sym.and_melchior); }
    {Or}                     { return symbol(sym.or_balthassar); }
    {Not}                     { return symbol(sym.not_gaspar); }

    //Operadores aritmeticos binarios
    {Addition}                     { return symbol(sym.sum_dasher); }
    {Substraction}                 { return symbol(sym.res_dancer); }
    {Product}                      { return symbol(sym.mul_prancer); }
    {DivisionInteger}              { return symbol(sym.div_int_vixen); }
    {DivisionFloat}              { return symbol(sym.div_float_blitzen); }
    {Mod}                          { return symbol(sym.mod_comet); }
    {Power}                          { return symbol(sym.pow_cupid); }

    //Operador de coma para separar elementos 
    {Comma}                        { return symbol(sym.SEPARAREGALO); }
    
    // Operadores de asignacion y comparacion 
    {Assignment}                   { return symbol(sym.ENTREGA); }
    "=="                           { return symbol(sym.e_jinglebell); }
    "!="                           { return symbol(sym.ne_tinseltoes); }
    "<"                            { return symbol(sym.l_slinky); }
    ">"                            { return symbol(sym.g_merryberry); }
    ">="                           { return symbol(sym.ge_snowflake); }
    "<="                           { return symbol(sym.le_candycane); }


    //Delimitador de expresiones
    {Delimiter}                    { return symbol(sym.FINREGALO); }
    
    //Identificador para variables
    {Identifier}                   { return symbol(sym.IDENTIFIER); }

    //Tipos de datos literales
    {Character}                    { return symbol(sym.REGALO);} 
    {Float}                        { return symbol(sym.l_float_padrenavidad);}
    {DecIntegerLiteral}            { return symbol(sym.l_int_dedmoroz); }
 

    //Cualquier otro carácter no reconocido
    .                              {return symbol(sym.ERROR);}
}


<STRING> {
    \"                             { yybegin(YYINITIAL); 
                                    return symbol(sym.t_string_nicolas, 
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


<YYINITIAL,ERROR> "_/" {
    // Fin de comentario no encontrado, se intenta recuperar
    yybegin(YYINITIAL);
    yycolumn += 2; // Avanzar dos caracteres para evitar un bucle infinito
    return symbol(sym.ERROR);
}


<YYINITIAL,ERROR> [^ \t\n\r\"\-\+]* {
    // Ignorar cualquier otro carácter durante la recuperación
    yycolumn += yylength();
    return symbol(sym.ERROR);
}


/* error fallback en caso de encontrar un caracter no reconocido*/
[^]                              { 
                                    yycolumn++;
                                    return symbol(sym.ERROR);
                                }
