package ParserLexer;

public class sym {
    /*Terminales constantes*/
    public static final int l_PAPANOEL = 21; //tipo papa noel
    public static final int DONNER = 10; //Suma
    public static final int PRIVATE = 4;
    public static final int PERSONA = 5; //Identifcador
    public static final int FIESTA = 15; //
    public static final int PUBLIC = 3; 
    public static final int STRING_LITERAL = 7;
    public static final int BOOLEAN = 12;
    public static final int EOF = 0;
    public static final int BREAK = 11;
    public static final int error = 1;
    public static final int EQ = 8;s
    public static final int ABSTRACT = 2;
    public static final int INTEGER_LITERAL = 6;
    public static final int FESTIVAL = 14; //
    public static final int EQEQ = 9;
    public static final int l_SANTA = 17; //Nombre de papa noel es tipos?
    public static final int NAVDIAD = 13; //Abstract
    public static final int ENTREGA = 18; //Asignacion lexema
    public static final String[] terminalNames = new String[] {
        "EOF",
        "error",
        "ABSTRACT"
    }
}