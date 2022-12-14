<%@ page import="java.sql.*,java.io.*,java.awt.*,java.awt.image.*,java.nio.file.*,java.util.*,java.util.zip.*,javax.imageio.*,java.nio.file.attribute.*" %>

<%
Connection con = null;
Statement st = null;
ResultSet rs = null;
String risp = "";

String key = request.getParameter("key");
String op = request.getParameter("operazione");

try{Class.forName("org.postgresql.Driver");}catch (Exception e) {}
try {
	con = DriverManager.getConnection();	
	st = con.createStatement();
	if(op!=null && key!=null){
		if(op.equals("registra")){
			st.executeUpdate("insert into persone(key, dati, tipo) values(" + key + ",'" + key + "',1)");
			risp = key;
		}
		if(op.equals("getdati")){
			rs = st.executeQuery("select * from persone where key = " + key);
			if(rs.next()){
				risp = rs.getString("tipo") + "\t" + rs.getString("dati");
			}else{
				risp = key;
			}
		}
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
