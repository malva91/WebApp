<%@ page import="java.sql.*,java.io.*,java.awt.*,java.awt.image.*,java.nio.file.*,java.util.*,java.util.zip.*,javax.imageio.*,java.nio.file.attribute.*" %>

<%
Connection con = null;
Statement st = null;
ResultSet rs = null;
String risp = "";

String key = request.getParameter("key");
String tagid = request.getParameter("tagId");

String tagtype = request.getParameter("tagType");
String dati = request.getParameter("dati");
String tagT5 = request.getParameter("tagT5");

tagid = tagid.replace('A','0').replace('B','1').replace('C','2').replace('D','3').replace('E','4').replace('F','5');
//System.out.println(key + " (" + tagid + ") (" + tagtype + ")");
try{Class.forName("org.postgresql.Driver");}catch (Exception e) {}
try {
	con = DriverManager.getConnection();	
	st = con.createStatement();
	if(tagid!=null && key!=null  && tagtype!=null){
		if(tagid.trim().equals("")) tagid = "0";
		rs = st.executeQuery("select tipo,luogo,casella from tags where id = " + tagid);
		if(rs.next()){
			risp = rs.getString(1) + "\n" + rs.getString(2)+ "\n" + rs.getString(3);
		}else{
			st.executeUpdate("insert into tags(data,id,tipo,luogo,casella,attivo) values(" + System.currentTimeMillis() + "," + tagid + ",0,'-','*',0)");
			risp = "0\n" + tagid;
		}
		st.executeUpdate("insert into contatti(quando,tag,persona,tipo,dati) values(" + System.currentTimeMillis() + "," + tagid + "," + key + "," + tagtype + ",'" + dati + "')");
	}
	if(tagT5!=null){
		for(String tt5:tagT5.trim().split(" ")){
			st.executeUpdate("insert into contatti(quando,tag,persona,tipo,dati) values(" + System.currentTimeMillis() + "," + tt5 + "," + key + "," + "5" + ",'" + dati + "')");
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
System.out.println(risp);
out.println(risp);
%>

