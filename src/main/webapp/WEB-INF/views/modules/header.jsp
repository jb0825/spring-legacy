
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!--
<div id="header">
  <a href="/" class="btn btn-light">File Upload</a>
  <div class="show-database">
    <span>Show DB:</span>
    <a href="/list/dhtmlx" class="btn btn-light">DHTMLX</a>
    <a href="/list" class="btn btn-light">Server Side Pagination</a>
  </div>
</div>
-->
<div id="header">
  <a href="/" class="btn btn-light">File Upload</a>
  <div class="show-database">
    <div class="current btn btn-light">
      <span>Show Database</span>
      <img src="/resources/dhtmlxSuite/codebase/imgs/dhxmenu_skyblue/dhxmenu_arrow_down.gif" />
    </div>
    <div class="list">
      <a href="/list/dhtmlx">DHTMLX</a>
      <a href="/list2">DHTMLX Pagination 구현</a>
      <a href="/list">Server Side Pagination</a>
    </div>
  </div>
</div>
<script>
  document.querySelector(".show-database .current").addEventListener("click", () =>
      document.querySelector(".show-database .list").classList.toggle("active")
  );
</script>

<h3>📋 신입개발자 1차 과제</h3>