import jflex.exceptions.*;
import java.io.*;
import ParserLexer.*;
import java_cup.*;

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

    public void pruebaLexer(String rutaScanear) throws Exception {
        Reader reader = new BufferedReader(new FileReader(rutaScanear));

        reader.read();
        // Leer del archivos
        // Escribirlo en un archivo
        // Linea y columna
        // Agregar el manejo de errores

        //

        /*
         * LexerCup lex = new Lexer(reader);
         * int i = 0;
         * 
         * Symbol token;
         * while(true)
         * {
         * token = lex.next_token();
         * if(token.sym != 0)
         * {
         * System.out.println("Token: " + token.sym + ", Valor: " +
         * (token.value==null?lex.yytext():token.value.toString()));
         * }
         * else{
         * System.out.println("Cantidad de lexemas encontrados: " + i)
         * return;
         * }
         * i++;
         * }
         */
    }

}
