<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>1차 과제</title>

  <link rel="stylesheet" type="text/css" href="/resources/css/list-dhtmlx.css">
  <link rel="stylesheet" type="text/css" href="/resources/css/common.css">

  <!-- BOOTSTRAP -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

  <!-- DHTMLX -->
  <script type="text/javascript" src="/resources/dhtmlxSuite/codebase/dhtmlx.js"></script>
  <link rel="stylesheet" href="/resources/dhtmlxSuite/codebase/dhtmlx.css">
  <link rel="stylesheet" href="/resources/dhtmlxSuite/skins/skyblue/dhtmlx.css">
</head>
<body>
<div class="wrap">
  <jsp:include page="modules/header.jsp"></jsp:include>

  <div style="width: 620px; height: 240px" id="grid"></div>
  <div id="page"></div>
  <a href="https://github.com/jb0825/spring-legacy" id="footer" target="_blank">https://github.com/jb0825/spring-legacy</a>
</div>

<script type="text/javascript">
  /* SERVER ERROR */
  const message = '${message}';
  if(message.length > 0) {
    alert(message);
    location.href = "/";
  }

  /* GRID */
  const grid = new dhtmlXGridObject('grid');
  const data = ${data};
  const jsonData = {rows: []}

  for (let idx in data) {
    const d = data[idx];
    jsonData.rows.push({
        id: idx,
        data: [d.id, d.pwd, d.name, d.level, d.description, d.regDate]
      });
  }

  grid.setImagePath("/resources/dhtmlxSuite/codebase/imgs/")
  grid.setHeader("ID,pwd,name,level,description,regDate");
  grid.setInitWidths("50,100,70,50,150,200");
  grid.setColSorting("str,str,str,str,str,str");
  grid.enablePaging(true,10,5,"page",true);
  grid.setPagingSkin("toolbar", "dhx_skyblue");
  grid.init();
  grid.parse(jsonData,"json");

</script>
</body>
</html>