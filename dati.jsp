<%@ page language="java" contentType="application/CSV; charset=ISO-8859-1" import="java.sql.*,java.io.*,java.awt.*,java.awt.image.*,java.nio.file.*,java.util.*,java.util.zip.*,javax.imageio.*,java.nio.file.attribute.*" %>

<%
//Response.Clear();
//response.ContentType = "application/CSV";
String filename = "operatore_codice_" + request.getParameter("key");
response.addHeader("content-disposition", "attachment; filename=\"" + filename + ".csv\"");
//Response.Write(t.ToString());
//Response.End();

Connection con = null;
Statement st = null;
ResultSet rs = null;

try{Class.forName("org.postgresql.Driver");}catch (Exception e) {}

try {
	con = DriverManager.getConnection();	
	st = con.createStatement();
	rs = st.executeQuery("select contatti.quando,persone.dati,tags.luogo,contatti.tipo from contatti,tags,persone where contatti.tipo > 0 and contatti.persona = persone.key and contatti.tag = tags.id and persona = " + request.getParameter("key") + " order by contatti.quando");
	out.println("quando\tchi\tluogo\tmoltiplicatore" );

	while(rs.next()){
		out.print(new java.util.Date(rs.getLong(1)) + "\t");
		out.print(rs.getString(2) + "\t");
		out.print(rs.getString(3) + "\t");
		switch(rs.getInt(4)){
			case 1: out.println("1"); break;
			case 2: out.println("0,5"); break;
			case 3: out.println("0,33"); break;
			case 4: out.println("0,25"); break;
			default: out.println("" + rs.getInt(4)); break;

		}		
	}
} catch (Exception e) {
	out.println("---- ERRORE SQL  ---- " + e);
}

try {
	if(st!= null) st.close();
	if(con!=null) con.close();
	st = null;
	con = null;
}catch(Exception e) {}

%>


