import ETL.Cleaner;
import ETL.Transformer;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.concurrent.TimeUnit;

public final class Main {

    private static final String LOCATION_EXCEL="./excel/test Napoli 20-10-2017.xlsx";

    private static final String LOCATION_CSV="./excel/test Napoli 20-10-2017.csv";

    private static final String PATH="./excel/duplicates";

    private static final int NUM_TEST=200;

    private static final boolean duplicate=false;

    public static void main(String[] args) {

        Multiplier multiplier=new Multiplier();
        Cleaner cleaner =new Cleaner();
        Long startTime;

        //Duplicate files
        if (duplicate) {
            System.out.println("Duplico i file");
            startTime = System.currentTimeMillis();
            for (int i = 0; i < NUM_TEST; i++) {
                multiplier.setWorkbook(loadEXCEL());
                multiplier.duplicate(PATH);
            }
            System.out.println("Tempo impiegato per duplicare: "+ TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis()-startTime)/200);
        }

        //Clean files
        startTime = System.currentTimeMillis();
        System.out.println("Pulisco i file");
        for (int i = 0; i < NUM_TEST; i++) {
            Workbook workbook=getWorkbook(i);
            if (workbook!=null) {
                cleaner.setWorkbook(workbook);
                cleaner.setCsvFile(createCSV(workbook.getSheetName(0)));
                cleaner.clean();
            }
        }
        System.out.println("Tempo impiegato per pulire: "+ TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis()-startTime)/200);

        //Transform files
        System.out.println("Transformo i file");
        startTime=System.currentTimeMillis();
        for (int i = 0; i < NUM_TEST; i++) {
            Transformer transformer=new Transformer();
            BufferedReader reader= loadCSV(i);
            if (reader!=null) {
                transformer.setReader(reader);
                transformer.transform();
                transformer.setCsvFile(createCSV(i));
            }
        }
        System.out.println("Tempo impiegato per trasformare: "+ TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis()-startTime)/200);
    }


    private static PrintWriter createCSV(String file){
        try {
           return new PrintWriter(PATH+"/csv/"+file+".csv", StandardCharsets.UTF_8);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    private static PrintWriter createCSV(int pos){
        File folder=new File(PATH+"/csv/");
        try {
            return new PrintWriter(folder.listFiles()[pos].toPath().toString(),StandardCharsets.UTF_8);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    private static XSSFWorkbook loadEXCEL(){
        File excelFile=new File(LOCATION_EXCEL);
        try {
           return new XSSFWorkbook(excelFile);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InvalidFormatException e) {
            e.printStackTrace();
        }
        return null;
    }

    private static XSSFWorkbook getWorkbook(int pos){
        File folder=new File(PATH);
        try {
            if (pos<folder.listFiles().length && folder.listFiles()[pos].isFile())
            return new XSSFWorkbook(folder.listFiles()[pos]);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InvalidFormatException e) {
            e.printStackTrace();
        }
        return null;
    }

    private static BufferedReader loadCSV(int pos){
        File folder=new File(PATH+"/csv/");
        try {
            if (pos<folder.listFiles().length && folder.listFiles()[pos].isFile())
                return Files.newBufferedReader(folder.listFiles()[pos].toPath());
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}
