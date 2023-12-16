import java.nio.file.*;

public class App {// Clase principal del programa a ejecutar
    /*
     * Descripcion: Funcion para generar un lexer basico usando JFlex
     * Parametros de entrada: Ninguno
     * Parametros de salida: Ninguno
     */
    public static void GenerarLexerParser() throws Exception {
        // Se definen las variables de las hileras que contienen las rutas de los
        // archivos y programas
        String basePath, fullPathLexer, fullPathParser, jlexer, jparser, jlexerCarpeta;

        // Se declara una instancia de la clase MainJFlexCup para construir el lexer
        MainJFlexCup mfjc;
        // Se obtiene la ruta del directorio donde se ubica el proyecto
        basePath = System.getProperty("user.dir");

        // Archivos .java del parser y el lexer
        jparser = "parser.java";
        jlexer = "Lexer.java";
        jlexerCarpeta = "ParserLexer";

        mfjc = new MainJFlexCup();

        // Se elimina el sym.java en caso de que exista
        Files.deleteIfExists(Paths.get(basePath + "\\src\\ParserLexer\\sym.java"));

        // Rutas para los archivos lexer y parser
        fullPathLexer = basePath + "\\src\\ParserLexer\\lexerCup.jflex";
        fullPathParser = basePath + "\\src\\ParserLexer\\parser.cup";

        // Se borran los archivos si ya existen
        Files.deleteIfExists(Paths.get(basePath + "\\src\\ParserLexer\\" + jparser));
        Files.deleteIfExists(Paths.get(basePath + "\\src\\ParserLexer\\" + jlexer));

        // Se genera el lexer y parser
        String[] strArrParser = { fullPathParser };
        mfjc.iniLexerParser(fullPathLexer, strArrParser);

        // Se generan el sym.java el parser.java y el lexer.java en la carpeta
        // ParserLexer
        Files.move(Paths.get(basePath + "\\sym.java"), Paths.get(basePath +
                "\\src\\ParserLexer\\sym.java"));
        Files.move(Paths.get(basePath + "\\" + jparser), Paths.get(basePath +
                "\\src\\ParserLexer\\" + jparser));

    }

    /*
     * Descripcion: Funcion para ejecutar la prueba del codigo
     * Parametros de entrada: Ninguno
     * Parametros de salida: Ninguno
     */
    public static void GenerarPrueba() throws Exception {
        // Se definen las hileras de las rutas
        String basePath, fullPathParser;
        MainJFlexCup mfjc; // Instancia de la clase ejecutadora de las pruebas

        basePath = System.getProperty("user.dir"); // Ruta del dir actual

        // Ruta del archivo de texto con el codigo de prueba
        fullPathParser = basePath + "\\src\\Prueba\\codigo.txt";

        mfjc = new MainJFlexCup();

        // Se ejecuta el analisis lexico del archivo de prueba
        mfjc.pruebaLexer2(fullPathParser);
    }

    /*
     * Descripcion: Funcion main para ejecutar el codigo
     * No recibe parametros obligatorios y no retorna nada.
     */
    public static void main(String[] args) throws Exception {
        /*
         * Descomentar para generar el lexer y el parser .java
         * Si se va a generar el lexer parser, se debe comentar el llamado a
         * GenerarPrueba para evitar problemas
         */

        // GenerarLexerParser();

        // Se ejecuta la prueba del archivo codigo.txt
        // Los resultados se guardan en el archivo resultado.txt
        GenerarPrueba();
    }
}