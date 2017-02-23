<%@ page language="java" contentType="text/html; charset=ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@ page import="regex.mutrex.*"%>
<%@ page import="regex.distinguishing.*"%>
<%@ page import="dk.brics.automaton.*"%>
<%@ page import="dk.brics.automaton.oo.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Generate strings from regex</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<style>
body {
	font-family: Arial, Helvetica Neue, Helvetica, sans-serif;
}

h1 {
	color: blue;
	background: white;
	margin-left: 0px;
}

table, th, td {
	border-collapse: collapse;
	border: 1px solid black;
}

th {
	height: 50px;
}

td {
	padding: 6px;
}
</style>
</head>
<body>
	<h1>MutRex: the mutation-based test generator for regular
		expressions</h1>
	<%
		if (request.getParameter("regex") == null) {
	%>
	<form action="index.jsp">
		Regex: <input type="text" name="regex">
		<button type="submit" name="action" value="generate">Generate
			strings</button>
		<p>
			MutRex algorithm: <br> <INPUT TYPE="radio" NAME="option"
				VALUE="BASIC" CHECKED>Basic algorithm<BR> <INPUT
				TYPE="radio" NAME="option" VALUE="MONITORING">Use monitoring<BR>
			<INPUT TYPE="radio" NAME="option" VALUE="COLLECTING">Use
			collecting<BR>
	</form>
	<hr>
	The syntax accepted by MutRex can be found here
	<a
		href="http://www.brics.dk/automaton/doc/dk/brics/automaton/RegExp.html">http://www.brics.dk/automaton/doc/dk/brics/automaton/RegExp.html</a>
	<br> MutRex supports also
	<br> \d is short for [0-9]
	<br> \w stands for "word character"
	<br> \s stands for "whitespace character"
	<br>
	<hr>
	Some examples can be downloaded
	<a href="mutation2017experiments.txt">here</a>
	<hr>
	mutrex is still experimental - see paper:
	<br> P. Arcaini, A. Gargantini, E. Riccobene
	<br>
	<i>MutRex: a mutation-based generator of fault detecting strings
		for regular expressions</i>
	<br> in 12th International Workshop on Mutation Analysis (Mutation
	2017), Tokyo, Japan, March 13, 2017 (to appear)
	<br>
	<a href="http://d3s.mff.cuni.cz/~arcaini/papers/mutrexMUTATION2017.pdf">[download
		the pdf]</a>
	<%
		} else {
			out.println("Strings for <b>" + request.getParameter("regex") + "</b>:<p	>");
			//String options[] = request.getParameterValues("option");
			String option = request.getParameter("option");
			DSSet ds = MutRex.generateStrings(request.getParameter("regex"), option);
	%>
	<table>
		<thead>
			<tr>
				<th>String</th>
				<th>Distinguished mutants</th>
			</tr>
			<tr>
				<th>Accepted</th><th></th>
			</tr>
		</thead>
		<tbody>
			<%
				for (DistinguishingString d : ds) {
						if (d.isConfirming()) {
							out.println("<tr>");
							out.println("<td>\"" + d.getDs() + "\"</td>");
							out.println("<td>");
							RegExpSet rs = ds.getKilledMutants(d);
							out.println("(size: " + rs.size() + ")");
							for (RegExp r : rs) {
								out.println(ToSimpleString.convertToReadableString(OORegexConverter.getOORegex(r)));
							}
							out.println("</td></tr>");
						}
					}
			%>

			<tr>
				<th>Rejected</th><th></th>
			</tr>
			<%
				for (DistinguishingString d : ds) {
						if (!d.isConfirming()) {
							out.println("<tr>");
							out.println("<td>\"" + d.getDs() + "\"</td>");
							out.println("<td>");
							RegExpSet rs = ds.getKilledMutants(d);
							out.println("(size: " + rs.size() + ")");
							for (RegExp r : rs) {
								out.println(ToSimpleString.convertToReadableString(OORegexConverter.getOORegex(r)));
							}
							out.println("</td></tr>");
						}
					}
			%>
		</tbody>
	</table>
	<%
		}
	%>
</body>
</html>