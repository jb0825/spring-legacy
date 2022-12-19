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

  <style>
    .dhx_toolbar_text { width: 150px; text-align: center; }
    #toolbar { width: 620px !important; }
  </style>
</head>
<body>
<div class="wrap">
  <jsp:include page="modules/header.jsp"></jsp:include>


  <div style="width: 620px; height: 240px" id="grid"></div>
  <div id="toolbar"></div>
  <a href="https://github.com/jb0825/spring-legacy" id="footer" target="_blank">https://github.com/jb0825/spring-legacy</a>
</div>

<script type="text/javascript">
  /* GRID */
  const grid = new dhtmlXGridObject('grid');

  grid.setImagePath("/resources/dhtmlxSuite/codebase/imgs/")
  grid.setHeader("ID,pwd,name,level,description,regDate");
  grid.setInitWidths("50,100,70,50,150,200");
  grid.setColSorting("str,str,str,str,str,str");
  grid.setPagingSkin("toolbar", "dhx_skyblue");
  grid.init();

  /* Grid data */
  const dateToString = d => {
    let date = new Date(d);
    return date.toLocaleDateString() + date.toLocaleTimeString();
  }
  const setGridData = data => {
    const jsonData = {rows: []};

    for (let idx in data) {
      const d = data[idx];
      jsonData.rows.push({
        id: idx,
        data: [d.id, d.pwd, d.name, d.level, d.description, dateToString(d.regDate)]
      });
    }
    grid.clearAll();
    grid.parse(jsonData, "json");
  }

  /* TOOLBAR */
  const imgUrl = "/resources/dhtmlxSuite/codebase/imgs/dhxgrid_skyblue/";
  const toolbar = new dhtmlXToolbarObject({
    parent: "toolbar",
    icon_path: imgUrl,
    items:[
      {id: "first", type: "button", img: "ar_left_abs.gif", img_disabled: "ar_left_abs_dis.gif"},
      {id: "prev", type: "button", img: "ar_left.gif", img_disabled: "ar_left_dis.gif"},
      {id: "info", type: "text", text: "Records from 1 to 10"},
      {id: "next", type: "button", img: "ar_right.gif", img_disabled: "ar_right_dis.gif"},
      {id: "last", type: "button", img: "ar_right_abs.gif", img_disabled: "ar_right_abs_dis.gif"},
      {id: "excel", type: "button", text: "Download", img:"excel.png"}
    ],
  });

  /* Toolbar Event */
  const handleToolbarClick = (name, pager) => {
    const {pageCount, pageNo, limit} = pager;

    if (name.match(/page\d{1}/)) getData(name.split("page")[1], limit);
    if (name.match(/rows\d{1}/)) getData(1, name.split("rows")[1]);
    else {
      switch (name) {
        case 'first':
          getData(1, limit);
          break;
        case 'prev':
          getData(pageNo - 1, limit);
          break;
        case 'next':
          getData(pageNo + 1, limit);
          break;
        case 'last':
          getData(pageCount, limit);
          break;
        case 'excel':
          grid.toExcel("https://dhtmlxgrid.appspot.com/export/excel");
          break;
      }
    }
  }

  /* Toolbar Select button Option */
  const getPageOpt = pageCount => {
    const pageOpt = [];

    for (let i = 1; i <= pageCount; i++)
      pageOpt.push(['page' + i, 'obj', 'Page ' + i, 'paging_page.gif']);
    return pageOpt;
  }
  const getRowsOpt = () => {
    const rowsOpt = [];

    for (let i = 5; i <= 30; i += 5)
      rowsOpt.push(['rows' + i, 'obj', i + ' rows per page', 'paging_page.gif']);
    return rowsOpt
  }

  /* Toolbar Buttons */
  const setBtns = (condition, elem) => {
    if (!condition) toolbar.disableItem(elem);
    else toolbar.enableItem(elem);
  }

  const setToolbar = pager => {
    const {prev, next, dataCount, pageCount, pageNo, limit} = pager;
    setBtns(prev, 'prev');
    setBtns(next, 'next');
    setBtns(pageNo !== 1, 'first');
    setBtns(pageNo !== pageCount, 'last');

    toolbar.removeItem("page-select");
    toolbar.addButtonSelect("page-select", 5, "Page 1", getPageOpt(pageCount), "paging_pages.gif");
    toolbar.setItemText("info", "Records from " + (pageNo * limit - limit + 1) + " to " + Math.min((pageNo * limit), dataCount));
    toolbar.setItemText("page-select", "Page " + pageNo);
    toolbar.setItemText("rows-select", limit + " rows per page");
  }

  /* First Request */
  $.ajax({
    url: "/user/page/1/10",
  }).done(data => {
    const {users, pager} = data;

    toolbar.addButtonSelect("page-select", 5, "Page 1", getPageOpt(pager.pageCount), "paging_pages.gif");
    toolbar.addButtonSelect("rows-select", 6, "10 rows per page", getRowsOpt(), "paging_rows.gif");
    toolbar.attachEvent("onClick", name => handleToolbarClick(name, pager));

    setGridData(users);
    setToolbar(pager);
  });

  /* AJAX Request */
  const getData = (pageNo, limit) => {
    $.ajax({
      url: "/user/page/" + pageNo + "/" + limit
    }).done(data => {
      const {success, message, users, pager} = data;

      if (!success) {
        console.log(message);
        alert("데이터 조회에 실패했습니다.");
        location.href = "/";
      }
      setGridData(users);
      setToolbar(pager);

      toolbar.detachAllEvents();
      toolbar.attachEvent("onClick", name => handleToolbarClick(name, pager));
    });
  }
</script>
</body>
</html>