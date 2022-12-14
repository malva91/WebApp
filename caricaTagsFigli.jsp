<%@ page import="java.sql.*,java.io.*,java.awt.*,java.awt.image.*,java.nio.file.*,java.util.*,java.util.zip.*,javax.imageio.*,java.nio.file.attribute.*" %>

<%
Connection con = null;
Statement st = null;
ResultSet rs = null;
String risp = "";
String idpadre = request.getParameter("padre");
try{Class.forName("org.postgresql.Driver");}catch (Exception e) {}
try {
	con = DriverManager.getConnection();	
	st = con.createStatement();
	rs = st.executeQuery("select * from tags where attivo > 0 and id between " + idpadre + "00" + " and " + idpadre + "99 order by id"); 
		
	while(rs.next()){
		risp += rs.getString("luogo")  + "\t" + rs.getString("id")  + "\t" + rs.getString("colore") + "\n";
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
%>

