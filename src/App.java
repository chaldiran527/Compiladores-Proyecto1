import java.nio.file.*;

public class App {

    public static void GenerarLexerParser() throws Exception {
        String basePath, fullPathLexer, fullPathParser, jlexer, jparser, jlexerCarpeta;
        MainJFlexCup mfjc;
        basePath = System.getProperty("user.dir");

        // .java del parser y el lexer
        jparser = "parser.java";
        jlexer = "Lexer.java";
        jlexerCarpeta = "ParserLexer";

        mfjc = new MainJFlexCup();

        // Se eleimina el sym.java en caso de que exista
        Files.deleteIfExists(Paths.get(basePath + "\\src\\ParserLexer\\sym.java"));

        fullPathLexer = basePath + "\\src\\ParserLexer\\lexerCup.jflex";
        fullPathParser = basePath + "\\src\\ParserLexer\\parser.cup";

        Files.deleteIfExists(Paths.get(basePath + "\\src\\ParserLexer\\" + jparser));
        Files.deleteIfExists(Paths.get(basePath + "\\src\\ParserLexer\\" + jlexer));

        String[] strArrParser = { fullPathParser };
        mfjc.iniLexerParser(fullPathLexer, strArrParser);

        Files.move(Paths.get(basePath + "\\sym.java"), Paths.get(basePath +
                "\\src\\ParserLexer\\sym.java"));
        Files.move(Paths.get(basePath + "\\" + jparser), Paths.get(basePath +
                "\\src\\ParserLexer\\" + jparser));
        // Files.move(Paths.get(basePath + "\\src\\" + jlexerCarpeta + "\\" + jlexer),
        // Paths.get(basePath + "\\src\\ParseLexer\\" + jlexer));
    }

    public static void GenerarBasico() throws Exception {
        String basePath, fullPathLexer;
        MainJFlexCup mfjc;

        basePath = System.getProperty("user.dir");

        fullPathLexer = basePath + "\\src\\ParserLexer\\lexerCup.jflex";

        mfjc = new MainJFlexCup();
        mfjc.GenerateLexer(fullPathLexer);

    }

    public static void GenerarPrueba() throws Exception {
        String basePath, fullPathParser;
        MainJFlexCup mfjc;

        basePath = System.getProperty("user.dir");
        fullPathParser = basePath + "\\src\\Prueba\\codigo.txt";

        mfjc = new MainJFlexCup();

        // mfjc.pruebaLexer(fullPathParser);
        mfjc.pruebaLexer2(fullPathParser);
    }

    public static void main(String[] args) throws Exception {
        String basePath = System.getProperty("user.dir");
        //System.out.println("This?");
        basePath = basePath + "\\src\\ParserLexer\\lexerCup.jflex";
        //System.out.println(basePath);
        
        GenerarLexerParser();

        GenerarBasico();
        GenerarPrueba();

    }
}

// Lectura y escritura -Juan
// Manejo de errores -Adrian
// Definir expresiones regulares -Juan
// Nombres navidenios en el jflex y en el cup de los terminales -Adrian

// Documentacion