<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>1차 과제</title>

    <link rel="stylesheet" type="text/css" href="/resources/css/list.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/common.css">

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
        <div class="first-btn">&lt;&lt;</div>
        <div class="prev-btn">prev</div>
        <div class="page-btns"></div>
        <div class="next-btn">next</div>
        <div class="last-btn" data-last="">&gt;&gt;</div>
    </div>
    <a href="https://github.com/jb0825/spring-legacy" id="footer" target="_blank">https://github.com/jb0825/spring-legacy</a>
</div>

<script type="text/javascript">
    const prevBtn  = document.querySelector(".prev-btn");
    const nextBtn  = document.querySelector(".next-btn");
    const firstBtn = document.querySelector(".first-btn");
    const lastBtn  = document.querySelector(".last-btn");
    const btns     = document.querySelector(".page-btns");

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
    });

    /* AJAX Request */
    const getData = (pageNo) => {
        $.ajax({
            url: "/user/page/" + pageNo
        }).done(data => {
            const {success, message, users, pager} = data;

            if (!success) {
                console.log(message);
                alert("데이터 조회에 실패했습니다.");
                location.href = "/";
            }
            grid.data.parse(users);
            setPager(pager);
        });
    }
    getData(1);

    /* page button click event */
    const handlePageClick = e => { getData(e.target.innerText) }
    const handlePrevNextClick = e => {
        if (!e.target.classList.contains("active")) {
            e.preventDefault();
            return;
        }
        let pageNo = document.querySelector(".page-btns .active").innerText;
        pageNo *= 1;

        getData(e.target.innerText === "prev" ? pageNo - 1 : pageNo + 1);
    }
    const handleFirstLastClick = e => {
        const target = e.target;
        getData(target.className === "first-btn" ? 1 : target.dataset.last);
    }

    /* set pagination buttons */
    const active = (condition, elem) => {
        if (condition) elem.classList.add("active");
        else elem.classList.remove("active");
    }
    const setPager = (pager) => {
        const {prev, next, pageCount, pageNo, startPage, endPage} = pager;
        const pageBtn = document.getElementsByClassName("page-btn");

        btns.innerHTML = "";

        for (let i = startPage; i <= endPage; i++)
            btns.innerHTML += "<div class='"+ (i == pageNo ? 'page-btn active' : 'page-btn') +"'>"+ i +"</div>";
        for (let btn of pageBtn) btn.addEventListener("click", handlePageClick);

        lastBtn.dataset["last"] = pageCount;

        active(prev, prevBtn);
        active(next, nextBtn);
    }

    prevBtn.addEventListener("click", handlePrevNextClick);
    nextBtn.addEventListener("click", handlePrevNextClick);
    firstBtn.addEventListener("click", handleFirstLastClick);
    lastBtn.addEventListener("click", handleFirstLastClick);
</script>
</body>
</html>