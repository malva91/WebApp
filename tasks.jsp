<%@ page import="java.sql.*,java.io.*,java.awt.*,java.awt.image.*,java.nio.file.*,java.util.*,java.util.zip.*,javax.imageio.*,java.nio.file.attribute.*" %>

<%
Connection con = null;
Statement st = null;
ResultSet rs = null;
String risp = "";
try{Class.forName("org.postgresql.Driver");}catch (Exception e) {}
try {
	con = DriverManager.getConnection();	
	st = con.createStatement();
	if(tagid!=null && key!=null  && tagtype!=null){
		rs = st.executeQuery("select tipo,luogo from tags where id = " + tagid);
		if(rs.next()){
			risp = rs.getString(1) + "\n" + rs.getString(2);
		}else{
			st.executeUpdate("insert into tags(data,id,tipo,luogo,casella) values(" + System.currentTimeMillis() + "," + tagid + ",0,'-','*')");
			risp = "0\n" + tagid;
		}
		st.executeUpdate("insert into contatti(quando,tag,persona,tipo) values(" + System.currentTimeMillis() + "," + tagid + "," + key + "," + tagtype + ")");
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


