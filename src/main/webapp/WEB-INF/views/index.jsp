<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>1차 과제</title>
    <style>
        #upload-fail, #upload-success, #upload-success table { display: none; }
        table {
            margin: 10px;
            border-collapse: collapse;
        }
        tr, th, td { border: 1px solid black; }
    </style>
</head>
<body>
<h1><%= "1차 과제" %>
</h1>
<br/>

<form id="file-form" method="post" action="/user" enctype="multipart/form-data" accept-charset="UTF-8" >
    <input type="file" name="file" accept=".dbfile"/>
    <button type="submit">submit</button>
</form>

<div id="upload-fail">
    <div id="info"></div>
    <div>실패한 라인번호와 텍스트: </div>
    <table>
        <tr><th>line</th><th>data</th></tr>
    </table>
</div>

<div id="upload-success">
    <button>조회</button>
    <table>
        <tr>
            <th>ID</th>
            <th>password</th>
            <th>name</th>
            <th>level</th>
            <th>description</th>
            <th>date</th>
        </tr>
    </table>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script type="text/javascript">
    const redirectMsg = '${message}';
    if (redirectMsg.length > 0) alert(redirectMsg);

    const form = document.getElementById("file-form");
    const input = form.querySelector("input");

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
            tr.innerHTML = "<td>" + temp[0] + "</td><td>" + temp[1] + "</td>";
            failTable.appendChild(tr);
        }

        failInfo.innerText = "성공: " + successCnt + "건, " + "실패: " + failCnt + "건";
        failArea.style.display = "block";
    }

    if (uploadData !== null && uploadData.length > 0) uploadResult();

    /* FILE UPLOAD SUCCESS */
    const handleBtnClick = event => {
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
    successBtn.addEventListener("click", e => handleBtnClick(e));

    /* UTIL */
    const dateToString = d => {
        let date = new Date(d);
        return date.toLocaleDateString() + date.toLocaleTimeString();
    }
</script>
</body>
</html>