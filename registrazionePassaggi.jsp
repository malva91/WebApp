<%@ page import="java.sql.*,java.io.*,java.awt.*,java.awt.image.*,java.nio.file.*,java.util.*,java.util.zip.*,javax.imageio.*,java.nio.file.attribute.*" %>

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
	rs = st.executeQuery("select contatti.quando,persone.dati,tags.luogo,contatti.dati,tags.casella  from contatti,tags,persone where contatti.tag = tags.id and contatti.persona = persone.key and contatti.tipo > 0 and contatti.dati like 'DATI:%' order by contatti.quando desc");
 
	while(rs.next()){
		Stack<String> record = new Stack();
		record.add(rs.getString(1));
		record.add(rs.getString(2));
		record.add(rs.getString(3));
		record.add(rs.getString(4) + "," + rs.getString(5));
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
%>

<html>
<head>
<meta name = "viewport" content = "width = device-width, minimum-scale = 1,initial-scale = 1">
   
<title>GESTIONE MONITORAGIO OPERATORI</title>
</head>
<style>
td{font-family:Verdana;font-size:10pt; border: solid thin grey;'}
a{font-family:Verdana;font-size:12pt;text-decoration:underline;color:white}

</style>
<body>
<table width='100%'><tr>
<td style='background-color:blue;color:white;text-align:center'><a style='background-color:blue;color:white;' href="codiciPersone.jsp">codici persone</a></td>
<td style='background-color:blue;color:white;text-align:center'><a style='background-color:blue;color:white;'  href="codiciTags.jsp">codici tags</a></td>
<td style='background-color:orangered;color:white;text-align:center'>passaggi</td>
</tr></table>

<H1>R E G I S T R A Z I O N E &nbsp;&nbsp; P A S S A G G I</H1>
<span style='font-size:10pt'>dati B&#38;B: tipo TAG,n.persone,checkout,area comune,refres,ore extra,sigla Excel,cella Excel</span>
<table >
<tr>
<td>data</td>
<td>operatore</td>
<td>luogo</td>
<td>dati</td>
</tr>

<%
for(Stack<String> record:dati){
	out.println("<tr>");

	for(int i=0; i<record.size(); i++){
		String dato = record.get(i);
		switch(i){
			case 0:
				out.println("<td>" + new java.util.Date(Long.parseLong(dato)).toString() + "</td>");
				break;
			default:
				out.println("<td>" + dato + "</td>");
				break;

		}
	}
	out.println("</tr>");
}
%>
</table>

</body>
</html>

