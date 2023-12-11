import jflex.exceptions.*;
import java.io.*;
import ParserLexer.*;
import java_cup.*;

public class MainJFlexCup {
    public void iniLexerParser(String rutaLexer, String[] strArrParser) throws internal_error, Exception{
        //GenerateLexer(rutaLexer);
        //GenerateParser(strArrParser);s

    }
    //Se genera el archivo del lexer
    public void GenerateLeer(String ruta) throws IOException, SilentExit{
        String[] strArr = {ruta};
        jflex.Main.generate(strArr);
    }

    //Se generan los archivos del parser
    public void Generateparser(String[] strArr) throws internal_error, IOException, Exception{
        java_cup.Main.main(strArr);
    }

}
