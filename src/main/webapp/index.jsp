<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@page
contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
  <head>
    <title>Orders manager</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="icon" type="image/png" href="./img/logo.png" />
    <!--Estilo de default-->
    <link rel="stylesheet" href="./default.css" />
    <!--Siempre tener en cuenta la dependecia-->
    <style>
      body div.w3-main iframe#myiframe {
        /*overflow:hidden;
        height:100%;
        width:100%;*/
        display: block;
        border: none;
        /*height: 100vh;Viewport-relative units */
        width: 100%;
      }
      div.scc_topco {
        z-index: 4;
        background-color: rgb(79, 192, 110);
        color: white;
        padding: 5px 2.5px;
        -webkit-box-shadow: 0px -2px 13px 0px #000000;
        box-shadow: 0px -2px 13px 0px #000000;
      }
      nav.scc_menu {
        -webkit-box-shadow: 0px 14px 10px 5px rgba(0, 0, 0, 0.1);
        box-shadow: 0px 14px 10px 5px rgba(0, 0, 0, 0.1);
      }
      hr {
        margin: 7.5px 0px;
      }
    </style>
  </head>
  <body class="w3-light-grey">
    <!-- Top container -->
    <c:import url="./design/top_container.html"></c:import>
    <!-- Sidebar/menu -->
    <c:import url="./design/sidebar.html"></c:import>
    <!-- !PAGE CONTENT! -->
    <div class="w3-main" style="margin-left: 300px; margin-top: 43px">
      <!-- Header -->
      <c:import url="./design/header.html"></c:import>
      <!-- Contents -->
      <div
        class="w3-container w3-card-2 w3-margin-left w3-margin-right w3-margin-bottom"
        style="padding: 0"
      >
        <iframe src="./main-board.html" name="myiframe" id="myiframe"></iframe>
      </div>
      <!-- Footer -->
      <c:import url="./design/footer.html"></c:import>
      <!-- End page content -->
    </div>
    <c:import url="./design/extras/modals.html"></c:import>
    <c:import url="./design/extras/reminder.html"></c:import>
    <script
      type="text/javascript"
      src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.6.11/vue.min.js"
    ></script>
    <script
      type="text/javascript"
      src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"
    ></script>
    <script
      type="text/javascript"
      src="./vendor/Fraction.js-4.0.12/fraction.min.js"
    ></script>
    <!--Estilo de default-->
    <script type="text/javascript" src="./default.js"></script>
    <script type="text/javascript">
      function resizeIframe(e) {
        let x = document.getElementById(e);
        x.style.height = x.contentWindow.document.body.scrollHeight + "px";
      }
    </script>
  </body>
</html>
