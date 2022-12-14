<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.awt.*" %>
<%@ page import="java.awt.image.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="java.util.zip.*" %>
<%@ page import="javax.imageio.*" %>
<%@ page import="java.nio.file.attribute.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>

<%
Connection con = null;
Statement st = null;
ResultSet rs = null;
String risp = "";
Stack<Stack<String>> dati = new Stack<>();
try{Class.forName("org.postgresql.Driver");}catch (Exception e) {}
try {
	con = DriverManager.getConnection();	
	st = con.createStatement();
	rs = st.executeQuery("select * from persone order by tipo,dati"); 
	while(rs.next()){
		Stack<String> record = new Stack();
		record.add(rs.getString("key"));
		record.add(rs.getString("dati"));
		record.add(rs.getString("tipo"));
		dati.add(record);
	}
} catch (Exception e) {
	risp = "---- ERRORE ---- " + e;
}
try {
	if(st!= null) st.close();
	if(con!=null) con.close();
	st = null;
	con = null;
}catch(Exception e) {}


out.println(risp);

String whatsHappened = "";
File file ;
int maxFileSize = 5000 * 1024;
int maxMemSize = 5000 * 1024;
String filePath = "/opt/tomcat/apache-tomcat-9.0.58/webapps/idra.civicae.it/";
String contentType = request.getContentType();
if (contentType!=null && contentType.indexOf("multipart/form-data") >= 0) {
	DiskFileItemFactory factory = new DiskFileItemFactory();
	factory.setSizeThreshold(maxMemSize);

	ServletFileUpload upload = new ServletFileUpload(factory);
	upload.setSizeMax( maxFileSize );
	try{ 
		java.util.List fileItems = upload.parseRequest(request);
		Iterator i = fileItems.iterator();
int n=0;
		while ( i.hasNext () ) {
			FileItem fi = (FileItem)i.next();
			if ( !fi.isFormField () )  {
				String fieldName = fi.getFieldName();
				String fileName = "Foglio_Ore.xlsx";//fi.getName();
				boolean isInMemory = fi.isInMemory();
				long sizeInBytes = fi.getSize();
				file = new File( filePath + fileName);
				fi.write( file ) ;
                	whatsHappened += n++ + " " + fi.getFieldName() + "; Uploaded Filename: " + filePath + fileName;
			}else{
				whatsHappened += n++ + " <<" + fi.getFieldName() + ":" + fi.getString() + ">>";
			}
		}
	}catch(Exception ex) {
		whatsHappened = "Errore " + ex;
	}
	out.println("trasferimento file avvenuto"); //whatsHappened + ":::");

}
int mese = Calendar.getInstance().get(Calendar.MONTH);

%>

<html>
<head>
<meta name = "viewport" content = "width = device-width, minimum-scale = 1,initial-scale = 1">
   
<title>GESTIONE MONITORAGIO OPERATORI</title>
</head>
<style>
td{font-family:Verdana;font-size:10pt}
a{font-family:Verdana;font-size:12pt;text-decoration:underline;color:white}

</style>
<body>
<table width='100%'><tr>
<td style='background-color:orangered;color:white;text-align:center'>codici persone</td>
<td style='background-color:blue;color:white;text-align:center'><a href="codiciTags.jsp">codici tags</a></td>
<td style='background-color:blue;color:white;text-align:center'><a href="registrazionePassaggi.jsp">passaggi</a></td>
</tr></table>
<H1>C O D I C I &nbsp;&nbsp; P E R S O N E</H1>
<table width='100%'><tr width='100%'>
<td width='50%' align='left'>
mese di riferimento: 
<select id='mese'>
<option value='0' <%=(mese==0?"selected":"")%> >gen</option>
<option value='1' <%=(mese==1?"selected":"")%> >feb</option>
<option value='2' <%=(mese==2?"selected":"")%> >mar</option>
<option value='3' <%=(mese==3?"selected":"")%> >apr</option>
<option value='4' <%=(mese==4?"selected":"")%> >mag</option>
<option value='5' <%=(mese==5?"selected":"")%> >giu</option>
<option value='6' <%=(mese==6?"selected":"")%> >lug</option>
<option value='7' <%=(mese==7?"selected":"")%> >ago</option>
<option value='8' <%=(mese==8?"selected":"")%> >set</option>
<option value='9' <%=(mese==9?"selected":"")%> >ott</option>
<option value='10' <%=(mese==10?"selected":"")%> >nov</option>
<option value='11' <%=(mese==11?"selected":"")%> >dic</option>
</select>
</td>
<td width='50%' align='right'>
<input id="fileupload" type="file" name="fileupload" /> 
<button id="upload-button" onclick="uploadFile()"> Upload </button>
</td></tr></table>
<hr>
<table>
<tr>
<td>codice</td>
<td>data acquisiz.</td>
<td>descrizione</td>
<td>tipo</td>
<td></td>
<td></td>
<td></td>
</tr>

<%
for(Stack<String> record:dati){
	out.println("<tr>");
	out.println("<td>" + record.get(0) + "</td>");
	out.println("<td>" + new java.util.Date(1000*Long.parseLong(record.get(0))) + "</td>");

	out.println("<td><input name='dt" +record.get(0)+"' id='dt" + record.get(0) + "' type='text' value='" + record.get(1) + "' ></td>");
	out.println("<td><input name='tp" +record.get(0)+"' id='tp" + record.get(0) + "' type='text' value='" + record.get(2) + "' size=1 ></td>");
	out.println("<td>" + "<button onclick='salvaDati(" + record.get(0) + ")' > " + "V" + "</button></td>");
	out.println("<td>" + "<button onclick='elimina(" + record.get(0) + ")' > " + "X" + "</button></td>");
	out.println("<td>" + "<button onclick='download(" + record.get(0) + ",\"" + record.get(1) + "\")' > " + "DOWNLOAD" + "</button></td>");
	out.println("</tr>");
}
%>
</table>

<script>


var xhttp;
if (window.XMLHttpRequest) {
   xhttp = new XMLHttpRequest();
} else {
   xhttp = new ActiveXObject("Microsoft.XMLHTTP");
}

function send(persona,dati){
	xhttp.onreadystatechange = function(){response();};
	xhttp.open("POST", "salvaDatiPersone.jsp?persona=" + persona + "&dati=" + dati.replace(' ','+'), true); //i dati hanno il seguente formato: &parametro=valore
	xhttp.send();
}
function response(){
	if (xhttp.readyState == 4 && xhttp.status == 200) {
		var risposta = xhttp.responseText;
		risposta = risposta.substring(0,risposta.indexOf("<html>"));
		alert(risposta.trim());
		
	}
}

function salvaDati(id){
	var dt = document.getElementById("dt" + id).value;
	var tp = document.getElementById("tp" + id).value;
	send(id,dt + ";" + tp);
}

function elimina(id){
	alert("Elimina " + id + "\nFUNZIONE DA IMPLEMENTARE");
}

function download(id,nome){
	location.href = "exc/toXLSX.jsp?chi=" + id + "&mese=" + document.getElementById("mese").value;
}

function uploadFile() {
	var file = document.getElementById("fileupload");
	
	/* Create a FormData instance */
	var fd = new FormData();

	/* Add the file */ 
	fd.append("tipo", "002");
	fd.append("key", "001");	
	fd.append("upload", file.files[0]);
	xhttp.onreadystatechange = function(){response();};
	xhttp.open("post","https://idra.civicae.it/codiciPersone.jsp", true);
	xhttp.send(fd);  /* Send to server */ 
}

</script>
</body>
</html>



 






