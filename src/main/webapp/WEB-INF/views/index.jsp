<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>1차 과제</title>

    <link rel="stylesheet" type="text/css" href="../../resources/css/index.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <style>
        #upload-fail, #upload-success, #upload-success table { display: none; }
    </style>
</head>
<body>
<div class="wrap">
<h3>📋 신입개발자 1차 과제</h3>
<form id="file-form" method="post" action="/user" enctype="multipart/form-data" accept-charset="UTF-8" >
    <label for="file" class="btn btn-secondary">파일 선택</label>
    <span id="file-info" class="btn">파일을 선택하세요</span>
    <input id="file" type="file" name="file" accept=".dbfile" />
    <button type="submit" class="btn btn-primary">submit</button>
</form>

<div id="upload-fail">
    <div id="info"></div>
    <div>실패한 라인번호와 텍스트: </div>
    <table class="table">
        <tr>
            <th scope="col">line</th>
            <th scope="col">data</th>
        </tr>
    </table>
</div>

<div id="upload-success">
    <button class="btn btn-info">🔎 DB 데이터 조회하기</button>
    <table class="table">
        <tr>
            <th scope="col">ID</th>
            <th scope="col">password</th>
            <th scope="col">name</th>
            <th scope="col">level</th>
            <th scope="col">description</th>
            <th scope="col">date</th>
        </tr>
    </table>
</div>

<a href="https://github.com/jb0825/spring-legacy" id="footer" target="_blank">https://github.com/jb0825/spring-legacy</a>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script type="text/javascript">
    const redirectMsg = '${message}';
    if (redirectMsg.length > 0) alert(redirectMsg);

    const form = document.getElementById("file-form");
    const input = form.querySelector("input");
    const label = form.querySelector("label");

    const failArea = document.getElementById("upload-fail");
    const failInfo = failArea.querySelector("#info");
    const failTable = failArea.querySelector("table");
    const uploadData = '${data}';

    const successArea = document.getElementById("upload-success");
    const successTable = successArea.querySelector("table");
    const successBtn = successArea.querySelector("button");

    /* FORM */
    const handleFormSubmit = (event) => {
        event.preventDefault();

        if (!input.value) {
            alert("파일을 선택해 주세요.");
            return;
        }
        form.submit();
    }
    form.addEventListener("submit", e => handleFormSubmit(e));

    /* INPUT FILE */
    const handleInputChange = () => {
        const fileInfo = document.getElementById("file-info");
        const arr = input.value.split("\\");

        fileInfo.innerText = !input.value ? "파일을 선택하세요" : "파일명: " + arr[arr.length - 1];
    }
    input.addEventListener("change", handleInputChange);

    /* FILE UPLOAD */
    const stringToArr = (data) => data.replace("{", "").replace("}", "").split(", ");
    const uploadResult = () => {
        const successCnt = '${success}';
        const failCnt = '${fail}';
        const data = stringToArr(uploadData);

        if (failCnt == 0) {
            alert(successCnt + " 건 입력에 성공했습니다.");
            successArea.style.display = "block";
            return;
        }

        for (let d of data) {
            const temp = d.split("=");
            let tr = document.createElement("tr");

            tr.innerHTML = "<td class='row'>" + temp[0] + "</td><td>" + temp[1] + "</td>";
            failTable.appendChild(tr);
        }
        failInfo.innerText = "✔ 성공: " + successCnt + "건  ❗ " + "실패: " + failCnt + "건";
        failArea.style.display = "block";
    }

    if (uploadData !== null && uploadData.length > 0) uploadResult();

    /* FILE UPLOAD SUCCESS */
    const handleBtnClick = () => {
        $.ajax({
            url: "/user", method: "GET",
        })
        .done(data => {
            for(let d of data) {
                let tr = document.createElement("tr");
                let str = "";

                for (let i in d) {
                    let temp = i === "regDate" ? dateToString(d[i]) : d[i];
                    str += ("<td>" + temp + "</td>");
                }
                tr.innerHTML = str;
                successTable.appendChild(tr);
            }
            successTable.style.display = "block";
            successBtn.setAttribute("disabled", true);
        })
        .fail(err => {
            alert("조회에 실패했습니다.");
            console.log(err);
        });
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