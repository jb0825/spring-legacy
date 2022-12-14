<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>1차 과제</title>

    <link rel="stylesheet" type="text/css" href="../../resources/css/index.css">
    <link rel="stylesheet" type="text/css" href="../../resources/css/common.css">

    <!-- BOOTSTRAP -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <!-- DHTMLX GRID -->
    <script type="text/javascript" src="../../resources/grid/codebase/grid.js"></script>
    <link rel="stylesheet" href="../../resources/grid/codebase/grid.css">
    <style>
        #upload-fail, #upload-success, #upload-success table { display: none; }
    </style>
</head>
<body>
<div class="wrap">
    <jsp:include page="modules/header.jsp"></jsp:include>

    <form id="file-form" method="post" action="/user" enctype="multipart/form-data" accept-charset="UTF-8" >
        <label for="file" class="btn btn-secondary">파일 선택</label>
        <span id="file-info" class="btn">파일을 선택하세요</span>
        <input id="file" type="file" name="file" accept=".dbfile" />
        <button type="submit" class="btn btn-primary">submit</button>
    </form>

    <div id="info"></div>

    <div id="upload-fail">
        <div>실패한 라인번호와 텍스트: </div>
        <div style="width:500px; height: 200px" id="fail_grid"></div>
    </div>

    <div id="upload-success">
        <button class="btn btn-info">🔎 DB 데이터 조회하기</button>
        <div style="width: 620px; height: 200px" id="success_grid"></div>
    </div>
    <a href="https://github.com/jb0825/spring-legacy" id="footer" target="_blank">https://github.com/jb0825/spring-legacy</a>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script type="text/javascript">
    const redirectMsg = '${message}';
    if (redirectMsg.length > 0) alert(redirectMsg);

    const form = document.getElementById("file-form");
    const input = form.querySelector("input");
    const info = document.querySelector("#info");

    const failArea = document.getElementById("upload-fail");
    const failTable = failArea.querySelector("table");
    const failData = '${info.data}';
    const success = '${info.success}';

    const successArea = document.getElementById("upload-success");
    const successBtn = successArea.querySelector("button");

    /* GRID */
    const failGrid = new dhx.Grid("fail_grid", {
        columns: [
            { width: 100, id: "line", header: [{ text: "line" }] },
            { width: 400, id: "text", header: [{ text: "fail data" }] },
        ],
        headerRowHeight: 40,
        rowHeight: 40,
    });
    const successGrid = new dhx.Grid("success_grid", {
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

    /* FORM */
    const handleFormSubmit = (event) => {
        event.preventDefault();

        if (!input.value) { alert("파일을 선택해 주세요."); return; }
        form.submit();
    }
    form.addEventListener("submit", e => handleFormSubmit(e));

    /* INPUT FILE */
    const handleInputChange = event => {
        const target = event.target;
        const fileInfo = document.getElementById("file-info");
        const arr = input.value.split("\\");

        if (target.files[0]) {
            const max = 5 * 1024 * 1024;

            if (target.files[0].size > max) {
                input.value = "";
                alert("5MB 이하의 파일을 선택하세요.");
            }
        }

        fileInfo.innerText = !input.value ? "파일을 선택하세요" : "파일명: " + arr[arr.length - 1];
    }
    input.addEventListener("change", e => handleInputChange(e));

    /* FILE UPLOAD */
    const uploadResult = () => {
        const fail = '${info.fail}';

        info.innerText = "✔ 성공: " + success + "건  ❗ " + "실패: " + fail + "건";
        failGrid.data.parse(failData);
        failArea.style.display = "block";
    }
    if (failData) uploadResult();
    else if (success) {
        info.innerText = "✔ 데이터 입력에 성공했습니다. [" + success + " 건]";
        successArea.style.display = "block";
    }

    /* FILE UPLOAD SUCCESS */
    const handleBtnClick = () => {
        $.ajax({
            url: "/user", method: "GET",
        })
        .done(data => {
            for (let d of data) d.regDate = dateToString(d.regDate);

            successGrid.data.parse(data);
            successBtn.setAttribute("disabled", true);
            successArea.querySelector("#success_grid").style.display = "block";
        }).fail(err => {
            console.log(err);
            alert("데이터 조회에 실패했습니다.");
        })
    }
    successBtn.addEventListener("click", handleBtnClick);

    /* UTIL */
    const dateToString = d => {
        let date = new Date(d);
        return date.toLocaleDateString() + date.toLocaleTimeString();
    }
</script>
</body>
</html>