<%@ page import="java.sql.*,java.io.*,java.awt.*,java.awt.image.*,java.nio.file.*,java.util.*,java.util.zip.*,javax.imageio.*,java.nio.file.attribute.*" %>

<%
Connection con = null;
Statement st = null;
ResultSet rs = null;
String risp = "";
String tt = request.getParameter("tt");
if(tt==null){
	tt="0";
}

Stack<Stack<String>> dati = new Stack<>();

try{Class.forName("org.postgresql.Driver");}catch (Exception e) {}
try {
	con = DriverManager.getConnection();	
	st = con.createStatement();
	if(request.getParameter("elimina")!=null){
		st.executeUpdate("delete from tags where id = " + request.getParameter("elimina")); 
	}
	if(request.getParameter("duplica")!=null){
		//verifico se è figlio
		rs = st.executeQuery("select * from tags where id = " + request.getParameter("duplica"));
		if(rs.next()){
			long nid = rs.getLong("id");
			int ntipo = rs.getInt("tipo");
			String nluogo = rs.getString("luogo");
			String ncas = rs.getString("casella");
			long ndata = System.currentTimeMillis();
			String ncolor = rs.getString("colore");
			int natt = rs.getInt("attivo");
			if(ntipo==4){ //creo nuovo tag
				rs = st.executeQuery("select max(id) from tags where id between " + nid + "00 and " + nid + "99");
				rs.next();
				if(rs.getString(1) == null){ // primo inserimento
					String qry = "insert into tags(id,tipo,luogo,casella,data,colore,attivo) values(";
					qry += nid + "01,5,'" + nluogo.replace("'","''") + "','" + ncas + "'," + ndata + ",'" + ncolor + "'," + natt + ")";
					st.executeUpdate(qry);
				}else{
					String qry = "insert into tags(id,tipo,luogo,casella,data,colore,attivo) values(";
					qry += (Long.parseLong(rs.getString(1)) + 1) + ",5,'" + nluogo.replace("'","''") + "','" + ncas + "'," + ndata + ",'" + ncolor + "'," + natt + ")";
					st.executeUpdate(qry);
				}
			}else if(ntipo==5){
				//cerco la base
				long nnid = nid/100;
				rs = st.executeQuery("select max(id) from tags where id between " + nnid + "00 and " + nnid + "99");
				rs.next();
				String qry = "insert into tags(id,tipo,luogo,casella,data,colore,attivo) values(";
				qry += (rs.getLong(1) + 1) + ",5,'" + nluogo.replace("'","''") + "','" + ncas + "'," + ndata + ",'" + ncolor + "'," + natt + ")";
				st.executeUpdate(qry);

			}
		}
	}

	if(request.getParameter("cecca")!=null){
		String chi = request.getParameter("cecca").split(",")[0].substring(2);
		
		String come = request.getParameter("cecca").split(",")[1];
		st.executeUpdate("update tags set attivo = " + come + " where id = " + chi); 
	}
	String selezione = "";
	if(tt != null){
		switch(tt){
			case "1": selezione = "where tipo = 1"; break;
			case "2": selezione = "where tipo = 2"; break;
			case "3": selezione = "where tipo = 3"; break;
			case "4": selezione = "where (tipo = 4 or tipo = 5)"; break;
			default: tt="0";
		}
	}
	rs = st.executeQuery("select * from tags " + selezione + " order by tipo,luogo,id"); 
	while(rs.next()){
		Stack<String> record = new Stack();
		record.add(rs.getString("id"));
		record.add(rs.getString("luogo"));
		record.add(rs.getString("tipo"));
		record.add(rs.getString("casella"));
		record.add(rs.getString("data"));
		record.add(rs.getString("colore"));
		record.add(rs.getString("attivo"));

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
td{font-family:Verdana;font-size:10pt}
a{font-family:Verdana;font-size:12pt;text-decoration:underline;color:white}

</style>
<body>
<table width='100%'><tr>
<td style='background-color:blue;color:white;text-align:center'><a href="codiciPersone.jsp">codici persone</a></td>
<td style='background-color:orangered;color:white;text-align:center'>codici tags</td>
<td style='background-color:blue;color:white;text-align:center'><a href="registrazionePassaggi.jsp">passaggi</a></td>
</tr></table>

<H1>C O D I C I &nbsp;&nbsp; T A G S
<select id='tipotag' onchange='ricarica()'>
<option value='1' <%=(tt.equals("1")?"selected":"")%> >1</option>
<option value='2' <%=(tt.equals("2")?"selected":"")%> >2</option>
<option value='3' <%=(tt.equals("3")?"selected":"")%> >3</option>
<option value='4' <%=(tt.equals("4")?"selected":"")%> >4</option>

</select>
</H1>
<table>

<tr>
<td>id</td>
<td>data acquisiz.</td>
<td>luogo</td>
<td>tipo</td>
<td>Excel</td>
<td>colore</td>
</tr>

<%
for(Stack<String> record:dati){
	out.println("<tr>");
	out.println("<td>" + record.get(0) + "</td>");
	out.println("<td>" + new java.util.Date(Long.parseLong(record.get(4))) + "</td>");
	out.println("<td><input name='dt" +record.get(0)+"' id='dt" + record.get(0) + "' type='text' value='" + record.get(1) + "' ></td>");
	out.println("<td><input name='tp" +record.get(0)+"' id='tp" + record.get(0) + "' type='text' value='" + record.get(2) + "' size=1 ></td>");
	out.println("<td><input name='cs" +record.get(0)+"' id='cs" + record.get(0) + "' type='text' value='" + record.get(3) + "' size=1 ></td>");
	out.println("<td><input name='cl" +record.get(0)+"' id='cl" + record.get(0) + "' type='color' value='#" + record.get(5) + "' size=1 ></td>");
	out.println("<td><input onchange='ceccato(this)' name='av" +record.get(0)+"' id='av" + record.get(0) + "' type='checkbox' " + (record.get(6).equals("1")?"checked":"") + " ></td>");
	out.println("<td>" + "<button onclick='salvaDati(" + record.get(0) + ")' > " + "S" + "</button></td>");
	if(tt.equals("4")){
		out.println("<td>" + "<button onclick='duplica(" + record.get(0) + ")' > " + "D" + "</button></td>");
	}
	out.println("<td>" + "<button onclick='elimina(" + record.get(0) + ")' > " + "X" + "</button></td>");
	out.println("</tr>");
}
%>
</table>

<script>
function salvaDati(id){
	var dt = document.getElementById("dt" + id).value;
	var tp = document.getElementById("tp" + id).value;
	var cs = document.getElementById("cs" + id).value;
	var cl = document.getElementById("cl" + id).value;

	send(id,dt,tp,cs,cl.replace('#',' ').trim());
}
function elimina(id){
	location.href = "https://idra.civicae.it/codiciTags.jsp?elimina=" + id;
}
function duplica(id){
	location.href = "https://idra.civicae.it/codiciTags.jsp?duplica=" + id;
}

function ceccato(chi){
	var url = "https://idra.civicae.it/codiciTags.jsp?tt=" + document.getElementById("tipotag").value + "&cecca=" + chi.id + "," + (chi.checked?"1":"0");
	location.href = url;
}
function ricarica(){
	var url = "https://idra.civicae.it/codiciTags.jsp?tt=" + document.getElementById("tipotag").value;
	location.href = url;
}

var xhttp;
if (window.XMLHttpRequest) {
   xhttp = new XMLHttpRequest();
} else {
   xhttp = new ActiveXObject("Microsoft.XMLHTTP");
}

function send(id,dt,tp,cs,cl){
console.log("salvaDatiTags.jsp?id=" + id + "&dt=" + dt.replace(' ','+') + "&tp=" + tp.replace(' ','+') + "&cs=" + cs.replace(' ','+') + "&cl=" + cl);

	xhttp.onreadystatechange = function(){response();};
	xhttp.open("POST", "salvaDatiTags.jsp?id=" + id + "&dt=" + dt.replace(' ','+') + "&tp=" + tp.replace(' ','+') + "&cs=" + cs.replace(' ','+') + "&cl=" + cl, true); //i dati hanno il seguente formato: &parametro=valore
	xhttp.send();
}
function response(){
	if (xhttp.readyState == 4 && xhttp.status == 200) {
		var risposta = xhttp.responseText;
		alert(risposta);
	}
}

</script>

</body>
</html>

