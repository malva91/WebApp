<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.nio.file.*,java.util.*,org.apache.poi.xssf.usermodel.*,org.apache.poi.ss.usermodel.*" %>

<%
String chi = request.getParameter("chi");
String mese = request.getParameter("mese");
String filename = (chi!=null?chi:"noname");
String persona = "noname";
String html = null;
HashMap<String,String> righe = new HashMap();
//recupero i dati di "chi"
java.sql.Connection con = null;
java.sql.Statement st = null;
java.sql.ResultSet rs = null;
try{Class.forName("org.postgresql.Driver");}catch (Exception e) {}
try {
	
	Calendar data = Calendar.getInstance();
	con = java.sql.DriverManager.getConnection();	
	st = con.createStatement();
	// aggiungeremo un contatti.quando between per selezionara il giorno
	rs = st.executeQuery("select contatti.quando,contatti.dati,contatti.tipo,tags.casella,tags.id from contatti,tags where contatti.tipo >= 0 and contatti.tag = tags.id and contatti.persona = " + chi + " order by contatti.quando " );
 
	while(rs.next()){
		data.setTimeInMillis(rs.getLong(1));
		
		String datiAggregati = rs.getString(2);
		if(data.get(Calendar.MONTH) == Integer.parseInt(mese) && datiAggregati != null && datiAggregati.startsWith("DATI:")){
			String chiave = data.get(Calendar.DAY_OF_MONTH) + rs.getString(5); 
			righe.put(chiave,data.get(Calendar.DAY_OF_MONTH) + "," + rs.getString(3) + "," + rs.getString(4) + "," + datiAggregati.substring("DATI:".length()));
		}
	}
	rs = st.executeQuery("select dati from persone where key = " + chi );
	if(rs.next()){
		persona = rs.getString(1);
		if(persona != null){
			persona = persona.replace(" ","_");
		}
	}
	

} catch (Exception e) {
	html = "<html><body><script>	alert('ERRORE in lettura: " + e + "');</script></body></html>";
	out.println(html);

}
try {
	if(st!= null) st.close();
	if(con!=null) con.close();
	st = null;
	con = null;
}catch(Exception e) {}

if(html==null){
try{
	//response.addHeader("content-disposition", "attachment; filename=\"" + filename + ".xlsx\"");

	//elaboro i dati dello Stack righe 
	
	Stack<String> valori = new Stack();
	for(String riga:righe.values()){ // 0:tipo;1:cod.cella;2:tipo;3:quantePersone;4:checkout;5:areacomune;6:refresh;7:oreextra;8:cod.cella;9:n.cella;10:giorno
		out.println(riga);
		String[] items = riga.split(",");
		float v=0;
		// v = (float)((float)Integer.parseInt(items[8])*1f/60.0f);
		// if(v>0){
		//	valori.add(items[2] + "," + v + "," + items[1] + "," + items[0]);
		// }

		switch(items[1]){
			case "0": //unica riga
				v = (float)((float)Integer.parseInt(items[8])*1f/60.0f);
				if(v>0){
					valori.add(items[2] + "," + v + "," + items[1] + "," + items[0]);
				}
				break;

			case "1": //unica riga
			case "4": //unica riga
			case "5": //unica riga

				v = (float)(1f/(float)Integer.parseInt(items[4]));
				if(v>0){
					valori.add(items[2] + "," + v + "," + items[1] + "," + items[0]);
				}
				break;

			case "2": //più righe
				v = (float)((float)Integer.parseInt(items[8])*1f/(float)Integer.parseInt(items[4]));
				if(v>0){
					valori.add(items[2] + "0," + v + "," + items[1] + "," + items[0]);
				}
				v = (float)((float)Integer.parseInt(items[5])*1f/(float)Integer.parseInt(items[4]));
				if(v>0){
					valori.add(items[2] + "1," + v + "," + items[1] + "," + items[0]);
				}
				v = (float)((float)Integer.parseInt(items[6])*1f/(float)Integer.parseInt(items[4]));
				if(v>0){
					valori.add(items[2] + "2," + v + "," + items[1] + "," + items[0]);
				}
				v = (float)((float)Integer.parseInt(items[7])*1f/(float)Integer.parseInt(items[4]));
				if(v>0){
					valori.add(items[2] + "3," + v + "," + items[1] + "," + items[0]);
				}
				break;
				case "3": //unica riga
				v = (float)(1f/(float)Integer.parseInt(items[3]));
				if(v>0){
					valori.add(items[2] + "," + v + "," + items[1] + "," + items[0]);
				}
				break;

		}
	}
	//duplico il file
	File basedir = new File("/opt/tomcat/apache-tomcat-9.0.58/webapps/idra.civicae.it/");
	File myFile = new File(basedir,"Foglio_Ore.xlsx");
	File newFile = new File(basedir,(1+ Integer.parseInt(mese)) + "_" + persona + ".xlsx");
	//Path original = myFile.toPath();
	//Path copia = newFile.toPath();
	//Files.copy(original, copia, StandardCopyOption.REPLACE_EXISTING);
	
	FileInputStream fis = new FileInputStream(myFile);

	// Finds the workbook instance for XLSX file
	XSSFWorkbook myWorkBook = new XSSFWorkbook (fis);

	// Return first sheet from the XLSX workbook
	XSSFSheet mySheet = myWorkBook.getSheetAt(0);
           
	// Get iterator to all the rows in current sheet
	Iterator<Row> rowIterator = mySheet.iterator();
           
	// Traversing over each row of XLSX file
	int rr = 0;
	while (rowIterator.hasNext()) {
		Row row = rowIterator.next();
/*
		if(rr==0){ //primo riga
			for(int gr=2; gr<33;gr++){
				Cell newCell = row.createCell(gr);	
				newCell.setCellValue(gr-1); 	
			}
		}
*/
		Cell cell = row.getCell(0);
		if(cell!=null){
try{
			String txt = cell.getStringCellValue();
			//controllo se ho una casella nel mio Stack dati uguale al valore della cella  
			for(String riga:valori){
				//out.println(txt + ":" + riga);
				String[] items = riga.split(","); //0:nome cella;1:valore
				//controllo formale
				if(items[0].equals(txt)){
					Cell newCell = row.createCell(1+Integer.parseInt(items[3]));	
					newCell.setCellValue(Float.parseFloat(items[1])); //valore non diviso	
					//cell.setCellValue((Integer) field);
				}
			}
		
}catch(Exception e){
//out.println("riga " + rr + ": " + e);
}
}
		rr++;
	}
	FileOutputStream fos = new FileOutputStream(newFile);
	myWorkBook.write(fos);
	myWorkBook.close();

	html = "<html><body><script>	location.href = 'https://idra.civicae.it/" + (1+ Integer.parseInt(mese)) + "_" + persona + ".xlsx';</script></body></html>";

	out.println(html);
}catch(Exception e){
	html = "<html><body><script>	alert(\"ERRORE: " + e + "\");</script></body></html>";

	out.println(html);

}
}
%>

