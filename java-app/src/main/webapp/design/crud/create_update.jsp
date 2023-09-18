<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" isELIgnored ="false" %>
<!DOCTYPE html>
<html lang="es">
  <head>
    <title>Orders manager</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="./default.css"/>
    <!--Para el mapa-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.6.0/leaflet.css"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.6.0/leaflet.js"></script>
    <!--Para fracciones-->
    <script src="./vendor/Fraction.js-4.0.12/fraction.min.js"></script>
    <script>
      function isNewor() {
        return '<%out.print(request.getParameter("nav"));%>' + "";
      }
      function getCom() {
        return '${com}' + "";
      }
    </script>
    <style>
      input.cambio{
        animation-name: icambio;
        animation-duration: .5s;
        animation-iteration-count: 1;
      }
      @keyframes icambio {
        0%   {background-color:rgba(208, 225, 225,.0);}
        50%  {background-color:rgba(208, 225, 225,.5);}
        75%  {background-color:rgba(208, 225, 225,1);}
        100% {background-color:rgba(208, 225, 225,.5);}
      }
      span.step {
        height: 15px;
        width: 15px;
        margin-top: 7.5px;
        padding: 0;
        background-color:  #bbbbbb;
        opacity: 0.37;
      }
      span.step.active {
        opacity: 1;
      }
      span.step.finish {
        background-color: #4CAF50;
      }
    </style>
  </head>
  <body class="scc_noselec" onload="parent.resizeIframe('myMFrame');">
    <div class="w3-show w3-animate-opacity w3-row-padding sbo" id="Tipo">
      <h3 class="w3-center"><b>Tipo de Pedido</b></h3>
      <div class="w3-row">
        <a href="javascript:void(0)" onclick="openTab(event, 'Normal');">
          <div class="w3-half sbo-tlink w3-bottombar w3-hover-light-grey w3-padding w3-center <c:out value="${clivals[8]==''&&clivals[10]==''? 'w3-border-teal': ''}"/>">Normal</div>
        </a>
        <a href="javascript:void(0)" onclick="openTab(event, 'Distribuidor');">
          <div class="w3-half sbo-tlink w3-bottombar w3-hover-light-grey w3-padding w3-center <c:out value="${clivals[8]==''&&clivals[10]!=''? 'w3-border-teal': ''}"/>">Distribuidor</div>
        </a>
      </div>
      <div id="Normal" class="w3-container sbo-tab w3-row-padding w3-section w3-animate-opacity" <c:if test="${clivals[8]!=''||clivals[10]!=''}">style="display:none"</c:if>>
          <div class="w3-col m4">
            <label>Nombre <strong class="w3-text-red">*</strong></label>
            <input class="w3-input w3-border jv-requ" oninput="normal(this)" maxlength="100" name="t-n_nombre" type="text" value="${clivals[0]}" onchange='findo(this, ${Acliente})' title="Campo obligatorio" list="lst-clientes"/>
          <datalist id="lst-clientes">
            <!-- TODO  Fix if clientes is 0 -->
            <c:forEach var = "i" begin = "0" end = "${fn:length(clientes)-1}">
              <option value="<c:out value = "${clientes[i]}"/>"></option>
            </c:forEach>
          </datalist>
        </div>
        <div class="w3-col m4">
          <label>Carnet de identidad</label>
          <input class="w3-input w3-border" type="text" name="t-n_ci" maxlength="15" value="${clivals[1]}"/>
        </div>
        <div class="w3-col m4">
          <label>Celular</label>
          <input class="w3-input w3-border" type="text" name="t-n_cel" maxlength="10" value="${clivals[2]}"/>
        </div>
        <div class="w3-col m4">
          <label>Email</label>
          <input class="w3-input w3-border" type="text" name="t-n_email" value="${clivals[3]}"/>
        </div>
        <div class="w3-col m4">
          <label>Usuario de facebook</label>
          <input class="w3-input w3-border" type="text" name="t-n_face" value="${clivals[4]}"/>
        </div>
        <div class="w3-col m4">
          <label>Recordar</label><br>
          <input class="w3-check" type="checkbox" name="t-n_sw" <c:if test="${clivals[5]=='1'}">checked=""</c:if>/>
          </div>
          <div class="m4">&nbsp;</div>
          <div class="w3-col m4">
            <input class="w3-radio" type="radio" name="same" <c:if test="${clivals[6]==''&&clivals[7]==''}">checked=""</c:if> onclick="showtohide('neve'); showtohide('ndis');"/> <label>Normal</label>
          <input class="w3-radio" type="radio" name="same" <c:if test="${clivals[6]!=''&&clivals[7]==''}">checked=""</c:if> onclick="hidetoshow('neve'); showtohide('ndis');"/> <label>Evento</label>
          <input class="w3-radio" type="radio" name="same" <c:if test="${clivals[6]==''&&clivals[7]!=''}">checked=""</c:if> onclick="hidetoshow('ndis'); showtohide('neve');"/> <label>Distribuidor</label>
          </div>
          <div class="w3-col m4">
            <input class="w3-input w3-border jv-requ <c:out value="${clivals[6]!=''&&clivals[7]==''? 'w3-show': 'w3-hide'}"/>" id="neve" name="t-n-e_name" type="text" value="${clivals[6]}" list="lst-even" oninput="normal(this)" maxlength="50">
          <datalist id="lst-even">
            <!-- TODO Fix if eventos is 0 -->
            <c:forEach var = "i" begin = "0" end = "${fn:length(eventos)-1}">
              <option value="<c:out value = "${eventos[i]}"/>"></option>
            </c:forEach>
          </datalist>
          <input class="w3-input w3-border jv-requ <c:out value="${clivals[6]==''&&clivals[7]!=''? 'w3-show': 'w3-hide'}"/>" id="ndis" name="t-n-d_name" type="text" value="${clivals[7]}" list="lst-distri" oninput="normal(this)" maxlength="50">
          <datalist id="lst-distri">
            <!-- TODO Fix if distribs is 0 -->
            <c:forEach var = "i" begin = "0" end = "${fn:length(distribs)-1}">
              <option value="<c:out value = "${distribs[i]}"/>"></option>
            </c:forEach>
          </datalist>
        </div>
      </div>
      <div id="Distribuidor" class="w3-container sbo-tab w3-row-padding w3-section w3-animate-opacity" <c:if test="${clivals[10]==''}">style="display:none"</c:if>>
          <div class="w3-col m4">
            <label>Nombre de distribuidor <strong class="w3-text-red">*</strong></label>
            <input class="w3-input w3-border jv-requ" maxlength="50" name="t-d_nombre" oninput="normal(this)" type="text" value="${clivals[10]}" title="Campo obligatorio" list="lst-distri" onchange="findos(this, 'lst-distri')"/>
        </div>
        <div class="w3-col m4">
          <label>Recordar</label><br>
          <input class="w3-check" type="checkbox" name="t-d_sw" <c:if test="${clivals[11]=='1'}">checked=""</c:if>/>
          </div>
        </div>
      </div>
      <!---->
      <div id="Detalle" class="w3-hide w3-animate-opacity w3-row-padding sbo">
        <datalist id="lst-tallas">
        <c:forEach var = "i" begin = "0" end = "${fn:length(tallas)-1}">
          <option value="<c:out value = "${tallas[i]}"/>"></option>
        </c:forEach>
      </datalist>
      <h3 class="w3-center"><b>Detalle de pedido</b></h3>
      <div class="w3-row-padding w3-section sbo-detalle">
        <div class="w3-col m2">
          <label>Codigo <strong class="w3-text-red">*</strong></label>
          <input class="w3-input w3-border sbo-detalle-code jv-requ" name="d-code" oninput="normal(this)" type="text"/>
        </div>
        <div class="w3-col m2">
          <label>Talla <strong class="w3-text-red">*</strong></label>
          <input class="w3-input w3-border sbo-detalle-talla jv-requ" name="d-talla" oninput="normal(this)" type="text" list="lst-tallas"/>
        </div>
        <div class="w3-col m2">
          <label>Cantidad <strong class="w3-text-red">*</strong></label>
          <input class="w3-input w3-border sbo-detalle-canti" onchange="cantidad(this)" name="d-cant" onkeydown="denis(event)" type="number" value="0" min="0" step="1"/>
        </div>
        <div class="w3-col m2">
          <label>Precio unidad <strong class="w3-text-red">*</strong></label>
          <input class="w3-input w3-border sbo-detalle-unit" onchange="preciou(this)" type="number" name="d-unit" value="0" min="0" step="0.1" value="0"/>
        </div>
        <div class="w3-col m2">
          <label>Total</label>
          <input class="w3-input w3-border sbo-detalle-subt" type="number" value="0" readonly="" disabled="" step="0.1"/>
        </div>
        <div class="w3-col m2">
          <br/>
          <button onclick="anadir(this)" class="w3-button w3-light-gray w3-round-xlarge w3-ripple w3-padding-small w3-hover-teal" title="Click para añadir vacio"><i class="fas fa-plus"></i></button>
          <button onclick="clonar(this)" class="w3-button w3-light-gray w3-round-xlarge w3-ripple w3-padding-small w3-hover-teal" title="Click para clonar"><i class="fas fa-copy"></i></button>
          <button onclick="quitar(this)" class="w3-button w3-light-gray w3-round-xlarge w3-ripple w3-padding-small w3-hover-teal" title="Click para remover fila"><i class="fas fa-minus"></i></button>
        </div>
      </div>
      <hr>
      <div class="w3-row-padding w3-section">
        <div class="w3-col m2">
          <label>SubTotal</label>
          <input class="w3-input w3-border" type="number" value="0" readonly="" disabled="" id="sbo-detalle-tot" step="0.1"/>
        </div>
        <div class="w3-col m2">
          <label>Envio <span class="w3-badge w3-cyan w3-text-white w3-tiny" title="Éste suma al subtotal para obtener el total"><b>?</b></span></label>
          <input class="w3-input w3-border" type="number" value="<c:out value="${fondos[0]==''? '0': fondos[0]}"/>" onchange="envio(true)" id="sbo-detalle-env" name="p-ext"  min="0" step="0.1"/>
        </div>
        <div class="w3-col m2">
          <label><i>Descuento <span class="w3-badge w3-cyan w3-text-white w3-tiny" title="Éste altera el total"><b>?</b></span></i></label>
          <select class="w3-select w3-border" id="sbo-detalle-desc" onchange="descontar()" name="p-desc">
            <option value="0.00" <c:if test="${fondos[9]=='0.00'}">selected=""</c:if>>0%</option>
            <option value="0.10" <c:if test="${fondos[9]=='0.10'}">selected=""</c:if>>10%</option>
            <option value="0.25" <c:if test="${fondos[9]=='0.25'}">selected=""</c:if>>25%</option>
            <option value="0.50" <c:if test="${fondos[9]=='0.50'}">selected=""</c:if>>50%</option>
            <option value="0.75" <c:if test="${fondos[9]=='0.75'}">selected=""</c:if>>75%</option>
            </select>
          </div>
          <div class="w3-col m2">
            <label><b>Total</b></label>
            <input class="w3-input w3-border" type="number" value="0" readonly="" disabled="" id="sbo-detalle-tott" step="0.1"/>
          </div>
          <div class="w3-col m2">
            <label>Acuenta <span class="w3-badge w3-cyan w3-text-white w3-tiny" title="Éste resta al total para obtener saldo"><b>?</b></span></label>
            <input class="w3-input w3-border" onchange="acuenta()" type="number" name="p-acont" value="<c:out value="${fondos[1]==''? '0': fondos[1]}"/>" min="0" step="0.1" id="sbo-detalle-aco"/>
        </div>
        <div class="w3-col m2">
          <label>Saldo</label>
          <input class="w3-input w3-border" type="number" value="0" readonly="" disabled="" id="sbo-detalle-sal" step="0.1"/>
        </div>
      </div>
    </div>
    <!---->
    <div id="Delivery" class="w3-hide w3-animate-opacity w3-center w3-row-padding sbo">
      <h3 class="w3-center"><b>Delivery</b></h3>
      <input title="Copie las coordenadas aqui" class="w3-input w3-border" style="width:50%;display: inline-block" onclick="this.setSelectionRange(0, this.value.length)" type="text" value="${fondos[8]}" name="p-delivery"/>
      <button class="w3-button w3-teal" onclick="searchMap(this.parentElement)">Ir</button>
      <button class="w3-button w3-teal" onclick="searchMapC(this.parentElement)">Copiar e Ir</button>
      <button class="w3-button w3-teal" onclick="homeMap(this.parentElement)">Home</button><br>
      <div id="mapid" style="height: 325px;width: 100%; display: inline-block; margin-top: 8px"></div>
    </div>
    <!---->
    <div id="Info" class="w3-hide w3-animate-opacity w3-row-padding sbo">
      <h3 class="w3-center"><b>Informacion extra</b></h3>
      <div class="w3-col m4">
        <label>Medio de contacto</label>
        <input class="w3-input w3-border" type="text" value="${fondos[2]}" list="lst-contacts" name="p-contacto"/>
        <datalist id="lst-contacts">
          <c:forEach var = "i" begin = "0" end = "${fn:length(medios)-1}">
            <option value="<c:out value = "${medios[i]}"/>"></option>
          </c:forEach>
        </datalist>
      </div>
      <div class="w3-col m4">
        <label>Lugar de destino</label>
        <input class="w3-input w3-border" type="text" value="${fondos[3]}" list="lst-destinos" name="p-destino"/>
        <datalist id="lst-destinos">
          <c:forEach var = "i" begin = "0" end = "${fn:length(destinos)-1}">
            <option value="<c:out value = "${destinos[i]}"/>"></option>
          </c:forEach>
        </datalist>
      </div>
      <div class="w3-col m4">
        <label>Medio de pago</label>
        <input class="w3-input w3-border" type="text" value="${fondos[4]}" list="lst-mpagos" name="p-pagos"/>
        <datalist id="lst-mpagos">
          <c:forEach var = "i" begin = "0" end = "${fn:length(pagos)-1}">
            <option value="<c:out value = "${pagos[i]}"/>"></option>
          </c:forEach>
        </datalist>
      </div>
      <div class="w3-col m4">
        <label>Comentario Propio</label>
        <textarea class="w3-input w3-border" type="ar" name="p-comm1">${fondos[5]}</textarea>
      </div>
      <div class="w3-col m4">
        <label>Comentario de Factura</label>
        <textarea class="w3-input w3-border" type="ar" maxlength="200" name="p-comm2">${fondos[6]}</textarea>
      </div>
      <div class="w3-col m4">
        <label>Fecha para Enviar <span class="w3-badge w3-cyan w3-text-white w3-tiny" title="Esta fecha aparece en su recibo"><b>?</b></span></label>
        <input class="w3-input w3-border jv-requ" type="date" onchange="normal(this)" name="p-enviar"<%
          String d = ((String[]) request.getAttribute("fondos"))[7];
          if (d.equals("")) {
            d = (new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));
            out.print("min='" + d + "' ");
          } else {
            out.print("value='" + d + "'");
          }
               %>/>
      </div>
    </div>
    <!---->
    <div id="Estado" class="w3-hide w3-animate-opacity w3-row-padding sbo">
      <h3 class="w3-center"><b>Estado de pedido</b></h3>
      <div class="w3-col m4">
        <label>Fecha de Ingreso</label>
        <input class="w3-input w3-border" id="date-entrante" type="date" oninput="normal(this)" name="e-entrante"<%
          d = ((String[]) request.getAttribute("estados"))[0];
          if (d.equals("")) {
            d = (new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));
          }
          if (((String[]) request.getAttribute("estados"))[5].equals("1")) {
            out.println("disabled='' ");
          }
          out.print("value='" + d + "'");
               %>/>
      </div>
      <div class="w3-col m4">
        <label>${estados[4]!="1"?'Fecha de Aprobado':'Fecha Rechazada'}</label>
        <input class="w3-input w3-border" id="date-aprobado" type="date" oninput="normal(this)" name="e-aprorec" value="${estados[1]}" <c:if test="${estados[5]=='1'}">disabled=""</c:if>/>
        </div>
        <div class="w3-col m4">
          <label>Fecha de Enviado</label>
          <input class="w3-input w3-border" id="date-enviado" type="date" oninput="normal(this)" name="e-enviado" value="${estados[3]}" <c:if test="${estados[4]=='1'||estados[5]=='1'}">disabled=""</c:if>/>
        </div>
        <div class="w3-col m4">
          <label>¿Está cancelado?</label><br>
          <input class="w3-radio" type="radio" name="e-cancel" value="1" onclick="cancel()" <c:if test="${estados[5]=='1'}">checked=""</c:if>/> <label>Si</label>
        <input class="w3-radio" type="radio" name="e-cancel" value="0" onclick="cancelno(this)" <c:if test="${estados[5]!='1'}">checked=""</c:if>/> <label>No</label>
        </div>
      </div>
      <div class="w3-center w3-section">
        <button type="button" id="prevBtn" onclick="nextPrev(-1)" class="w3-button w3-ripple w3-margin-right" disabled="">&#x276e;</button>
        <span class="w3-badge step w3-border active"></span>
        <span class="w3-badge step w3-border"></span>
        <span class="w3-badge step w3-border"></span>
        <span class="w3-badge step w3-border"></span>
        <span class="w3-badge step w3-border"></span>
        <button type="button" id="nextBtn" onclick="nextPrev(1)" class="w3-button w3-ripple w3-margin-left">&#x276f;</button>
      </div>
      <!--<button id="save-new" class="w3-button w3-ripple w3-teal w3-center w3-half" disabled="" onclick="save()"><b>Guardar</b></button>
      <button id="cleans" class="w3-button w3-ripple w3-center w3-half"><b>Limpiar actual</b></button>-->
    </body>
    <script>
      let currentTab = 0;
      function nextPrev(n) {
        let x = document.querySelectorAll("div.sbo");
        if (n === 1 && !validateForm()) {
          return false;
        }
        remClase(x[currentTab], 'w3-show', 'w3-hide');
        currentTab = currentTab + n;
        if (currentTab >= x.length) {
          return false;
        }
        showTab(currentTab);
      }
      function showTab(n) {
        let x = document.querySelectorAll("div.sbo");
        remClase(x[n], 'w3-hide', 'w3-show');
        if (n === 0) {
          document.getElementById("prevBtn").disabled = true; /*style.display = "none"*/
        } else {
          document.getElementById("prevBtn").disabled = false; /*style.display = "inline"*/
        }
        if (n === (x.length - 1)) {
          /*if (document.getElementById('save-new') !== null) {
           document.getElementById('save-new').disabled = false;
           }*/
          document.getElementById("nextBtn").disabled = true; /*style.display = "none"*/
        } else {
          /*if (document.getElementById('save-new') !== null) {
           document.getElementById('save-new').disabled = true;
           }*/
          document.getElementById("nextBtn").disabled = false; /*style.display = "inline"*/
        }
        fixStepIndicator(n);
        parent.resizeIframe('myMFrame');
      }
//inicia con true, en la posicion con la que encontro diferente de vacio!
      function recursivo(posicion, dom, std) {
        if (posicion === -1) {
          return std;
        } else {
          dom[posicion].className += (dom[posicion].value === "") ? " w3-pale-yellow" : "";
          return std && recursivo((posicion - 1), dom, (dom[posicion].value !== "")); //true!!es true va a decir
        }
      }

      function validateForm() {//jv-requ, ALGUNOS SERAN SELECT, DE ECHO SOLO UNO CUIDADO
        //la validacion funciona al incio con los que tienen la clase jv-requi
        //para el detalle son solo talla y codigo los que tendran
        //en informacion extra no hay validacion, al igual que en estado de pedido y deliveri.....!
        let valid = true;
        let y = document.querySelectorAll("div.sbo")[currentTab];
        if (y.id === 'Tipo') {
          for (let item of y.querySelectorAll('div.sbo-tab')) {
            if (item.style.display !== 'none') {
              for (let me of item.querySelectorAll("input.jv-requ")) {
                if (me.value === "" && !me.classList.contains('w3-hide')) {
                  me.className += " w3-pale-yellow";
                  valid = false;
                }
              }
            }
          }
        } else if (y.id === 'Estado') {
          y = y.querySelectorAll("input[type='date']");//
          for (let i = (y.length - 1); i >= 0; i--) {
            if (y[i].value !== "") {
              valid = recursivo((i - 1), y, true);
              break;
            }
          }
        } else {
          y = y.querySelectorAll("input.jv-requ");
          for (let i = 0; i < y.length; i++) {
            if (y[i].value === "") {
              y[i].className += " w3-pale-yellow";
              valid = false;
            }
          }
        }
        if (valid) {
          document.getElementsByClassName("step")[currentTab].className += " finish";
        } else {
          remClase(document.getElementsByClassName("step")[currentTab], " finish", "");
        }
        return valid;
      }
      function lastval() {
        let valid = false;
        if (document.getElementsByClassName("step").length > 1) {
          valid = validateForm() && document.getElementsByClassName("step").length === (currentTab + 1);
        }
        return valid;
      }
      /**This function removes the "active" class of all steps.
       * @@param {Integer} n - */
      function fixStepIndicator(n) {
        let x = document.querySelectorAll("span.step");
        for (let i = 0; i < x.length; i++) {
          remClase(x[i], " active", "");
        }
        x[n].className += " active";
      }
    </script>
    <script>
      /**Abre o cierra el acordeon.
       * @param {DOM} id - El id correspondiente
       function open_close(id) {
       var x = document.getElementById(id);
       if (x.classList.contains("w3-show")) {
       remClase(x, " w3-show", "");
       remClase(x.previousElementSibling, "w3-red", "w3-black");
       } else {
       x.className += " w3-show";
       remClase(x.previousElementSibling, "w3-black", "w3-red");
       }
       }*/
      /**Abre o cierra el tab.
       * @param {DOM} evt Elemento actual
       * @param {String} tabname Id de la tab a abrir.*/
      function openTab(evt, tabname) {
        Array.prototype.forEach.call(document.querySelectorAll('div.sbo-tab'), a => {
          a.style.display = "none";
          for (let me of a.querySelectorAll("input.jv-requ")) {
            remClase(me, "w3-pale-yellow", "");
          }
        });
        Array.prototype.forEach.call(document.querySelectorAll('div.sbo-tlink'), a => {
          remClase(a, " w3-border-teal", "");
        });
        document.getElementById(tabname).style.display = "block";
        evt.currentTarget.firstElementChild.className += " w3-border-teal";
        parent.resizeIframe('myMFrame');
      }
      /**Reemplaza la clase por otra.
       * @param {DOM} e
       * @param {String} from Valor a buscar
       * @param {String} to Valor a reemplazar*/
      function remClase(e, from, to) {
        e.className = e.className.replace(from, to);
      }
    </script>
    <script>
      function hidetoshow(id1) {
        let css = document.getElementById(id1);
        if (css.classList.contains('w3-hide')) {
          remClase(css, 'w3-hide', 'w3-show');
          css.value = '';
        }
      }
      function showtohide(id1) {
        let css = document.getElementById(id1);
        if (css.classList.contains('w3-show')) {
          remClase(css, 'w3-show', 'w3-hide');
          css.value = '';
        }
      }
    </script>
    <script>
      async function searchMapC(e) {
        let d = e.getElementsByTagName('input')[0];
        let text = await navigator.clipboard.readText();
        d.value = text;
        try {
          d = text.replace(" ", "");
          let str = d.split(",");
          let xx = parseFloat(str[0]);
          let yy = parseFloat(str[1]);
          marker.setLatLng([xx, yy]);
          mymap.setView([xx, yy], 17);
          //map.panTo(position);
        } catch (error) {
          alert('No se puede buscar');
          //d.value = '';
        }
      }
      function searchMap(e) {
        try {
          let d = e.getElementsByTagName('input')[0].value;
          d = d.replace(" ", "");
          let str = d.split(",");
          let xx = parseFloat(str[0]);
          let yy = parseFloat(str[1]);
          marker.setLatLng([xx, yy]);
          mymap.setView([xx, yy], 17);
          //map.panTo(position);
        } catch (error) {
          alert('No se puede buscar');
        }
      }
      function homeMap(e) {
        try {
          let d = e.getElementsByTagName('input')[0];
          marker.setLatLng([x, y]);
          mymap.setView([x, y], 11);
          //
          d.value = '';
        } catch (error) {
          alert('No se puede buscar');
        }
      }
      let x = 51.505;
      let y = -0.09;
      let mymap = L.map('mapid').setView([x, y], 11);
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
        maxZoom: 18
      }).addTo(mymap);
      L.control.scale().addTo(mymap);
      L.circle([x, y], {
        color: 'teal',
        fillOpacity: 0,
        radius: 1450
      }).addTo(mymap);
      L.circle([x, y], {
        color: 'green',
        fillOpacity: 0,
        radius: 3450
      }).addTo(mymap);
      L.circle([x, y], {
        color: 'orange',
        fillOpacity: 0,
        radius: 5200
      }).addTo(mymap);
      L.circle([x, y], {
        color: 'blue',
        fillOpacity: 0,
        fillRule: 'nonzero',
        radius: 7150
      }).addTo(mymap);
      L.circle([x, y], {
        color: 'red',
        fillOpacity: 0,
        radius: 12600
      }).addTo(mymap);
      let marker = new L.marker([x, y], {
        draggable: 'true'
      }).addTo(mymap);
      marker.on('dragend', function (event) {
        let position = marker.getLatLng();
        mymap.setView(position, 17);
        document.getElementById('Delivery').getElementsByTagName('INPUT')[0].value = position.lat.toFixed(6) + ',' + position.lng.toFixed(6);
      });
      function aftermap() {
        if (document.getElementById('Delivery').getElementsByTagName('INPUT')[0].value !== "")
          searchMap(document.getElementById('Delivery'));
      }
      //mymap.addLayer(marker);
    </script>
    <script>
      function acuenta() {
        try {
          let acco = new Fraction(document.getElementById('sbo-detalle-aco').value);
          if (acco.s === -1) {
            throw "No valido";
          }
          alterar(document.getElementById('sbo-detalle-sal'), (new Fraction(document.getElementById('sbo-detalle-tott').value)).sub(acco).valueOf(), true);
        } catch (e) {
          console.log(e);
          alert("Valor introducido no aceptado");
        }
      }
      function descontar(e) {
        try {
          let desco = new Fraction(document.getElementById('sbo-detalle-desc').value);
          if (desco.s === -1) {
            throw "No valido";
          }
          if (typeof e === 'undefined') {
            calc_total(false);//evita que se llame a si mismo
          }
          let total = (new Fraction(document.getElementById('sbo-detalle-tott').value));
          alterar(document.getElementById('sbo-detalle-tott'), total.sub(total.mul(desco)).round(1).valueOf(), true);
          acuenta();
        } catch (e) {
          console.log(e);
          alert("Valor introducido no aceptado");
        }
      }
      function envio(em) {
        try {
          let acco = new Fraction(document.getElementById('sbo-detalle-env').value);
          if (acco.s === -1) {
            throw "No valido";
          }
          alterar(document.getElementById('sbo-detalle-tott'), (new Fraction(document.getElementById('sbo-detalle-tot').value)).add(acco).valueOf(), em);
          if (em) {//em=true, solo cuando se hace el total normal.
            descontar(1);
          }
        } catch (e) {
          console.log(e);
          alert("Valor introducido no aceptado");
        }
      }
      function calc_total(tst) {
        let suma = new Fraction("0");
        Array.prototype.forEach.call(document.getElementById('Detalle').querySelectorAll('input.sbo-detalle-subt'), a => {
          suma = suma.add(new Fraction(a.value));
        });
        alterar(document.getElementById('sbo-detalle-tot'), suma.valueOf(), tst);
        envio(tst);
      }
      function alterar(e, str, sw) {
        e.value = str;
        if (sw) {
          if (e.classList.contains("cambio")) {
            remClase(e, " cambio", "");
          }
          void e.offsetWidth;
          e.className += " cambio";
        }
      }
      function denis(event) {
        if (event.key === '.') {
          event.preventDefault();
        }
      }
      function cantidad(e) {
        try {
          let can = e.value;
          if (parseInt(can) < 0)
            throw "No valido";
          let pu = (new Fraction(e.parentElement.nextElementSibling.getElementsByTagName('INPUT')[0].value));
          if (pu.s === -1) {
            throw "No valido";
          }
          alterar(e.parentElement.nextElementSibling.nextElementSibling.getElementsByTagName('INPUT')[0], (pu.mul(can).valueOf() + ""), true);
          calc_total(true);
        } catch (e) {
          console.log(e);
          alert("Valor introducido no aceptado");
        }
      }
      function preciou(e) {
        try {
          let can = e.parentElement.previousElementSibling.getElementsByTagName('INPUT')[0].value;
          if (parseInt(can) < 0)
            throw "No valido";
          let pu = (new Fraction(e.value));
          if (pu.s === -1) {
            throw "No valido";
          }
          alterar(e.parentElement.nextElementSibling.getElementsByTagName('INPUT')[0], (pu.mul(can).valueOf() + ""), true);
          calc_total(true);
        } catch (e) {
          console.log(e);
          alert("Valor introducido no aceptado");
        }
      }
    </script>
    <script>
      function anadir(e) {
        let div = e.parentElement.parentElement;
        let clon = div.cloneNode(true);
        //escoger que valores resetear
        clon.getElementsByClassName('sbo-detalle-code')[0].value = "";
        clon.getElementsByClassName('sbo-detalle-talla')[0].value = ""; //select
        clon.getElementsByClassName('sbo-detalle-canti')[0].value = "0";
        clon.getElementsByClassName('sbo-detalle-unit')[0].value = "0";
        clon.getElementsByClassName('sbo-detalle-subt')[0].value = "0";
        remClase(clon.getElementsByClassName('sbo-detalle-subt')[0], " cambio", ""); //un bug
        //mostrar
        div.insertAdjacentElement("afterend", clon); //div.parentElement.parentElement.appendChild(clon);
        parent.resizeIframe('myMFrame');
      }
      function clonar(e) {
        let div = e.parentElement.parentElement;
        let clon = div.cloneNode(true);
        clon.getElementsByClassName('sbo-detalle-talla')[0].value = div.getElementsByClassName('sbo-detalle-talla')[0].value; //un bug
        div.insertAdjacentElement("afterend", clon); //div.parentElement.parentElement.appendChild(clon);
        calc_total(true);
        parent.resizeIframe('myMFrame');
      }
      function quitar(e) {
        let nows = document.getElementById('Detalle').querySelectorAll('div.sbo-detalle');
        if (nows.length > 1) {
          e.parentElement.parentElement.remove();
          calc_total(true);
          parent.resizeIframe('myMFrame');
        }
      }
    </script>
    <script>
      function findos(ele, st) {
        let y = document.getElementById(st).getElementsByTagName("OPTION");
        let tmp = true;
        for (let i = 0; i < y.length; i++) {
          if (y[i].value === ele.value) {
            tmp = false;
            ele.parentElement.nextElementSibling.getElementsByTagName("INPUT")[0].checked = true;
            break;
          }
        }
        if (tmp) {
          ele.parentElement.nextElementSibling.getElementsByTagName("INPUT")[0].checked = false;
        }
      }
      function findo(ele, lst) {
        let curr = lst.find(function (elm) {
          if (elm.hasOwnProperty('nombre') && elm['nombre'] === ele.value) {
            return elm;
          }
        });
        if (curr !== undefined) {
          let inputs = ele.parentNode.parentNode.getElementsByTagName("input");
          inputs[1].value = curr['ci'];
          inputs[2].value = curr['celular'];
          inputs[3].value = curr['email'];
          inputs[4].value = curr['face'];
          inputs[5].checked = true;
        } else {//debate
          let inputs = ele.parentNode.parentNode.getElementsByTagName("input");
          inputs[1].value = "";
          inputs[2].value = "";
          inputs[3].value = "";
          inputs[4].value = "";
          inputs[5].checked = false;
        }
      }

      function normal(elem) {
        remClase(elem, ' w3-pale-yellow', '');
      }
    </script>
    <script>
      function hacerentran(bool) {
        if (isNewor() !== "") {
          document.getElementById('date-entrante').disabled = bool;
        }
      }
      function cancel() {
        hacerentran(true); //si desabilitas y es nuevo obtienes la fecha que tiene aca o 
        document.getElementById('date-aprobado').disabled = true;
        document.getElementById('date-terminado').disabled = true;
        document.getElementById('date-enviado').disabled = true;
      }
      function cancelno(e) {
        hacerentran(false);
        document.getElementById('date-aprobado').disabled = false;
        document.getElementById('date-terminado').disabled = false;
        document.getElementById('date-enviado').disabled = false;
      }
      function deltair() {
        let arreglo =${detalle};
        if (arreglo.length !== 0) {
          for (let i = 0; i < arreglo.length; i++) {
            let all = document.getElementById('Detalle').querySelectorAll('div.sbo-detalle');
            let cds = all[(all.length - 1)];
            let clon = cds.cloneNode(true);
            cds.getElementsByClassName('sbo-detalle-code')[0].value = arreglo[i].codigo;
            cds.getElementsByClassName('sbo-detalle-talla')[0].value = arreglo[i].talla; //select
            cds.getElementsByClassName('sbo-detalle-canti')[0].value = arreglo[i].cantidad;
            cds.getElementsByClassName('sbo-detalle-unit')[0].value = arreglo[i].precio;
            cantidad(cds.getElementsByClassName('sbo-detalle-canti')[0]);
            //cds.getElementsByClassName('sbo-detalle-subt')[0].value = "0";
            remClase(cds.getElementsByClassName('sbo-detalle-subt')[0], " cambio", ""); //un bug
            remClase(clon.getElementsByClassName('sbo-detalle-subt')[0], " cambio", ""); //un bug
            //mostrar
            if (i !== (arreglo.length - 1)) {
              cds.insertAdjacentElement("afterend", clon);
            }
          }
          parent.resizeIframe('myMFrame');
        }
      }
      if (isNewor() === "") {//es nuevo
        document.getElementById('date-entrante').disabled = true;
      } else {
        deltair();
        aftermap();
        //remClase(document.getElementById('save-new'), "w3-teal", "w3-blue");
        //document.getElementById('save-new').getElementsByTagName('B')[0].innerHTML = "Actualizar";
      }
  </script>
  <script>
    function save() {
      let on = new Object();
      let man = new Object();
      for (let item of document.querySelectorAll('div.sbo-tab')) {
        if (item.style.display !== 'none') {
          for (let me of item.querySelectorAll("input")) {
            if (me.attributes['type'].value === "text" && !me.classList.contains('w3-hide')) {
              on[me.attributes['name'].value.toString()] = me.value.toString();
            } else if (me.attributes['type'].value === "checkbox") {
              let val = me.checked ? "1" : "0";
              on[me.attributes['name'].value.toString()] = val;
            }
          }
        }
      }
      man.tipo = on;
      //on = new Object();---cronologicamente no necesario
      //--detalle
      let arr = new Array();
      Array.prototype.forEach.call(document.getElementById('Detalle').querySelectorAll('div.sbo-detalle'), a => {
        on = new Object();
        let sml = a.querySelectorAll("input");
        for (let i = 0; i < 4; i++) {
          on[sml[i].attributes['name'].value.toString()] = sml[i].value.toString();
        }
        arr.push(on);
      });
      on = new Object();
      man.detalle = arr;
      arr = new Array();
      //-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--+-+-+-+-+-+-+-+-+--+-+-+-+
      makeinput(document.getElementById("sbo-detalle-env"));
      makeinput(document.getElementById("sbo-detalle-desc"));
      makeinput(document.getElementById("sbo-detalle-aco"));
      makeinput(document.getElementById("Delivery").getElementsByTagName("INPUT")[0]);
      Array.prototype.forEach.call(document.getElementById('Info').querySelectorAll('input'), a => {
        makeinput(a);
      });
      Array.prototype.forEach.call(document.getElementById('Info').querySelectorAll('textarea'), a => {
        makeinput(a);
      });
      on['p-rcb'] = isNewor();
      man.pedido = on;
      on = new Object();
      Array.prototype.forEach.call(document.getElementById('Estado').querySelectorAll('input'), a => {
        if (a.type === "radio") {
          if (a.checked) {
            makeinput(a);
          }
        } else if (a.type === "date") {
          makeinput(a);
        }
      });
      //abra en pestaña el pdf
      man.estado = on;
      on = new Object();
      //loadDoc(man);
      function makeinput(e) {
        on[e.attributes['name'].value.toString()] = e.value.toString();
      }
      /*  function loadDoc(mans) {
       parent.mdlSend();
       let xhttp = new XMLHttpRequest();
       xhttp.onreadystatechange = function (ed) {
       if (this.readyState === 4 && this.status === 200) {
       JSON.parse(this.responseText);
       parent.cLoad(true);
       parent.cDone();
       }
       };
       xhttp.open("POST", getCom() + "?tt=123&ky=CUP&dd=" + JSON.stringify(mans), true);
       xhttp.send();
       }*/
      return man;
    }
    function getpaRecibo() {// se ejecuta una vez ya se tiene todo aceptado!!
      //estado es lo unico a verificar.
      let sw = false;
      let ysd = document.getElementById('Estado');
      if (!(ysd.querySelectorAll("input[type='radio']")[0].checked)) {//cancelado
        sw = (document.getElementById('date-aprobado').value !== "") && (document.getElementById('date-entrante').value !== "");
      }
      return sw;
    }
  </script>
</html>
