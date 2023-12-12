import jflex.exceptions.*;
import java.io.*;
import ParserLexer.Lexer;
import java_cup.*;
//import java_cup.Lexer;
import java_cup.runtime.Symbol;

public class MainJFlexCup {
    public void iniLexerParser(String rutaLexer, String[] strArrParser) throws internal_error, Exception {
        GenerateLexer(rutaLexer);
        Generateparser(strArrParser);

    }

    // Se genera el archivo del lexer
    public void GenerateLexer(String ruta) throws IOException, SilentExit {
        String[] strArr = { ruta };
        jflex.Main.generate(strArr);
    }

    // Se generan los archivos del parser
    public void Generateparser(String[] strArr) throws internal_error, IOException, Exception {
        java_cup.Main.main(strArr);
    }
    /*
     * public void pruebaLexer(String rutaScanear) throws Exception {
     * Reader reader = new BufferedReader(new FileReader(rutaScanear));
     * 
     * reader.read();
     * // Leer del archivos
     * // Escribirlo en un archivo
     * // Linea y columna
     * // Agregar el manejo de errores
     * 
     * //
     * 
     * Lexer lex = new Lexer(reader);
     * int i = 0;
     * 
     * Symbol token;
     * while (true) {
     * token = lex.next_token();
     * if (token.sym != 0) {
     * System.out.println("Token: " + token.sym + ", Valor: " +
     * (token.value == null ? lex.yytext() : token.value.toString()));
     * } else {
     * System.out.println("Cantidad de lexemas encontrados: " + i);
     * return;
     * }
     * i++;
     * }
     * 
     * }
     */

    public void pruebaLexer2(String rutaScanear) throws Exception {
        Reader reader = new BufferedReader(new FileReader(rutaScanear));
        // Leer del archivos
        // Escribirlo en un archivo
        // Linea y columna
        // Agregar el manejo de errores

        Lexer lex = new Lexer(reader);

        int i = 0;
        Symbol token;

        // Se especifica la ruta del archivo
        String outputPath = (System.getProperty("user.dir")) + "\\src\\Prueba\\resultado.txt";
        BufferedWriter writer = new BufferedWriter(new FileWriter(outputPath));

        while (true) {
            token = lex.next_token();
            if (token.sym != 0) {
                String tokenInfo = "Token: " + token.sym + ", Valor: " +
                        (token.value == null ? lex.yytext() : token.value.toString());
                System.out.println(tokenInfo);

                // Se escribe la info del token en el archivo
                writer.write(tokenInfo);
                writer.newLine();
            } else {
                String cantLexemas = "Cantidad de lexemas encontrados: " + i;
                System.out.println(cantLexemas);

                // Write the lexeme count information to the file
                writer.write(cantLexemas);
                writer.newLine();

                writer.close(); // Close the writer before returning
                return;
            }
            i++;
        }
    }

}
