<%@ page import="java.sql.*,java.io.*,java.awt.*,java.awt.image.*,java.nio.file.*,java.util.*,java.util.zip.*,javax.imageio.*,java.nio.file.attribute.*" %>

<%
Connection con = null;
Statement st = null;
ResultSet rs = null;
String risp = "";
String id = request.getParameter("id");
String dt = request.getParameter("dt");
String tp = request.getParameter("tp");
String cs = request.getParameter("cs");
String cl = request.getParameter("cl");
String qry = "";
try{Class.forName("org.postgresql.Driver");}catch (Exception e) {}
try {
	con = DriverManager.getConnection();	
	st = con.createStatement();
	if(id!=null && dt!=null && tp!=null && cs!=null){
		qry = "update tags set luogo = '" + dt + "', tipo=" + tp + ", casella='" + cs + "', colore='" + cl + "'  where id = " + id; 
System.out.println(qry);
		st.executeUpdate(qry);
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

