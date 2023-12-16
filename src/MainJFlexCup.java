import jflex.exceptions.*;
import java.io.*;
import ParserLexer.Lexer;
import ParserLexer.sym;
import java_cup.*;
import java_cup.runtime.Symbol;

public class MainJFlexCup {// Clase principal que incializa y ejecuta pruebas del jflex
    /**
     * Funcion que inicializa el lexer y parser generando los archivos
     * correspondientes.
     * 
     * @param rutaLexer    Ruta del archivo .jflex del lexer.
     * @param strArrParser Arreglo de argumentos para la generación del parser.
     * @throws internal_error Excepción interna de Cup.
     * @throws Exception      Otras excepciones que puedan ocurrir durante la
     *                        inicialización.
     */
    public void iniLexerParser(String rutaLexer, String[] strArrParser) throws internal_error, Exception {
        GenerateLexer(rutaLexer);
        Generateparser(strArrParser);

    }

    /**
     * Funcion que genera el archivo del lexer utilizando JFlex.
     * 
     * @param ruta Ruta del archivo .jflex del lexer.
     * @throws IOException Excepción de entrada/salida.
     * @throws SilentExit  Excepción específica de JFlex.
     */
    // Se genera el archivo del lexer
    public void GenerateLexer(String ruta) throws IOException, SilentExit {
        String[] strArr = { ruta };
        jflex.Main.generate(strArr);
    }

    /**
     * Funcion que genera los archivos del parser utilizando CUP.
     * 
     * @param strArr Arreglo de argumentos para la generación del parser.
     * @throws internal_error Excepción interna de Cup.
     * @throws IOException    Excepción de entrada/salida.
     * @throws Exception      Otras excepciones que puedan ocurrir durante la
     *                        generación.
     */
    // Se generan los archivos del parser
    public void Generateparser(String[] strArr) throws internal_error, IOException, Exception {
        java_cup.Main.main(strArr);
    }

    /**
     * Funcion que realiza el análisis léxico en un archivo de prueba, imprimiendo
     * información
     * de cada token encontrado y guardando la cantidad de lexemas en el archivo
     * resultado.txt.
     * 
     * @param rutaScanear Ruta del archivo a escanear.
     * @throws Exception Otras excepciones que puedan ocurrir durante el análisis.
     */
    public void pruebaLexer2(String rutaScanear) throws Exception {
        Reader reader = new BufferedReader(new FileReader(rutaScanear));

        Lexer lex = new Lexer(reader);

        int i = 0;
        Symbol token;

        // Se especifica la ruta del archivo de salida
        String outputPath = (System.getProperty("user.dir")) + "\\src\\Prueba\\resultado.txt";
        // Se inicializa el writer para escribir sobre el archivo
        BufferedWriter writer = new BufferedWriter(new FileWriter(outputPath));

        while (true) {
            token = lex.next_token();
            if (token.sym != 0) {
                /*
                 * Se define y escribe la hilera con la informacion del token con su codigo,
                 * nombre, valor, linea y columna con el que aparecen en el codigo.txt
                 */
                String tokenInfo = "Codigo Token: " + token.sym +
                        ", Nombre Token: " + sym.terminalNames[token.sym] +
                        ", Valor: " + (token.value == null ? lex.yytext() : token.value.toString()) +
                        ", Linea: " + (token.left + 1) + ", Columna: " + (token.right + 1) + "\n";
                System.out.println(tokenInfo); // Se imprime en consola la info
                writer.write(tokenInfo); // Se escribe en el archivo txt la info
                writer.write("\n");
            } else {
                String cantLexemas = "Cantidad de lexemas encontrados: " + i;
                System.out.println(cantLexemas);

                // Se escribe la cantidad de lexemas en el archivo
                writer.write(cantLexemas);
                writer.newLine();

                writer.close(); // Se cierra el writer
                return;
            }
            i++; // Se incrementa el contador de lexemas
        }
    }

}
