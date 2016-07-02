<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include virtual="/Connections/DB.asp" -->
<%
lblTitle = "<Table Title>"
lblTitleSub = "<Table Subtitle>"
' SQL
lwSQL = "select * from vStatAccDaily"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<%
Set tMember_cmd = Server.CreateObject ("ADODB.Command")
tMember_cmd.ActiveConnection = MM_GateDB_STRING
tMember_cmd.CommandText = lwSQL
tMember_cmd.Prepared = true

Set Rs = tMember_cmd.Execute

strtd = ""
i = 0
while not Rs.EOF
        strtd = strtd & "<tr align=""right"">"
        for each fldf in Rs.fields
                  strName = fldf.name
                  strValue = fldf.value
                  if not isnull(strValue) then
                          strValue = replace(strValue, "<", "&lt;")
                          strValue = replace(strValue, ">", "&gt;")
                  end if
            if i = 0 then
                  strth = strth & "<th bgcolor=""EEEEEE"">" & strName & "</th>"
            end if
            strtd = strtd & "<td bgcolor=FFFFFF>" & strValue & "</td>"
        next
        strtd = strtd & "</tr>"
        i = i + 1
        Rs.movenext
WEND
strth = "<tr>" & strth & "</tr>"
%>

<br />
<center><b><%=lblTitle%></b></center><br />
<center><%=lblTitleSub%></center><br />
<table border="1" align="center" cellpadding="2" cellspacing="0">
<%=strth%>
<%=strtd%>
</table>
</body>
</html>
