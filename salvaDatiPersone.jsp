<%@ page import="java.sql.*,java.io.*,java.awt.*,java.awt.image.*,java.nio.file.*,java.util.*,java.util.zip.*,javax.imageio.*,java.nio.file.attribute.*" %>

<%
Connection con = null;
Statement st = null;
ResultSet rs = null;
String risp = "";
String persona = request.getParameter("persona");
String dati = request.getParameter("dati");
try{Class.forName("org.postgresql.Driver");}catch (Exception e) {}
try {
	con = DriverManager.getConnection();	
	st = con.createStatement();
	if(persona!=null && dati!=null){
		st.executeUpdate("update persone set dati = '" + dati.split(";")[0] + "',tipo=" + dati.split(";")[1]  + " where key = " + persona); 
	}
	risp = "Salvataggio eseguito";
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
%>
