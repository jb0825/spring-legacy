<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>1차 과제</title>

    <link rel="stylesheet" type="text/css" href="../../resources/css/list.css">
    <link rel="stylesheet" type="text/css" href="../../resources/css/common.css">

    <!-- BOOTSTRAP -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <!-- DHTMLX -->
    <script type="text/javascript" src="/resources/grid/codebase/grid.js"></script>
    <link rel="stylesheet" href="/resources/grid/codebase/grid.css">
</head>
<body>
<div class="wrap">
    <jsp:include page="modules/header.jsp"></jsp:include>

    <div style="width: 620px; height: 240px" id="grid"></div>

    <div id="page-div">
        <div class="prev-btn">
            <a>prev</a>
        </div>
        <div class="page-btns">
            <c:forEach var="idx" begin="${pager.startPage}" end="${pager.endPage}">
                <c:if test="${pager.pageNo == idx}">
                    <a class="page-btn active" href="/list?pageNo=${idx}">${idx}</a>
                </c:if>
                <c:if test="${pager.pageNo != idx}">
                    <a class="page-btn" href="/list?pageNo=${idx}">${idx}</a>
                </c:if>
            </c:forEach>
        </div>
        <div class="next-btn">
            <a>next</a>
        </div>
    </div>
    <a href="https://github.com/jb0825/spring-legacy" id="footer" target="_blank">https://github.com/jb0825/spring-legacy</a>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script type="text/javascript">
    /* SERVER ERROR */
    const message = '${message}';
    if(message.length > 0) {
        alert(message);
        location.href = "/";
    }

    /* GRID */
    const grid = new dhx.Grid("grid", {
       columns: [
           { width: 50, id: "id", header: [{ text: "ID" }] },
           { width: 100, id: "pwd", header: [{ text: "password" }] },
           { width: 70, id: "name", header: [{ text: "name" }] },
           { width: 50, id: "level", header: [{ text: "level" }] },
           { width: 150, id: "description", header: [{ text: "description" }] },
           { width: 200, id: "regDate", header: [{ text: "date" }] },
       ],
        headerRowHeight: 40,
        rowHeight: 40,
        data: ${data}
    });

    const pageDiv = document.getElementById("page-div");

    /* PREV & NEXT BUTTON */
    const buttonActive = (btn) => {
        const activeBtn = pageDiv.querySelector(btn);
        activeBtn.classList.add("active");
        const uri = btn.includes("prev") ?
            "/list?pageNo=${pager.pageNo - 1}" :
            "/list?pageNo=${pager.pageNo + 1}";
        activeBtn.querySelector("a").setAttribute("href", uri);
    }

    if (${pager.prev}) buttonActive(".prev-btn");
    if (${pager.next}) buttonActive(".next-btn");
</script>
</body>
</html>