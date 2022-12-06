<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>JSP - Hello World</title>
</head>
<body>
<h1><%= "Hello World!" %>
</h1>
<br/>

<form id="file-form" method="post" action="/user" enctype="multipart/form-data" accept-charset="UTF-8" >
    <input type="file" name="file" accept=".dbfile"/>
    <button type="submit">submit</button>
</form>

<script type="text/javascript">
    const form = document.getElementById("file-form");
    const input = form.querySelector("input");

    const handleFormSubmit = (event) => {
        event.preventDefault();

        if (!input.value) {
            alert("파일을 선택해 주세요.");
            return;
        }

        form.submit();
    }

    form.addEventListener("submit", e => handleFormSubmit(e));
</script>
</body>
</html>