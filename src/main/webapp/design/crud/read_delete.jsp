<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ page
language="java" contentType="text/html" pageEncoding="UTF-8" isELIgnored
="false" %>
<!--Cambiar los VUE por propios de JSP, dado que una sola vez se cambia y no altera, empero definir la clase sera un problema
-->
<!DOCTYPE html>
<html lang="es">
  <head>
    <title>Orders manager</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="icon" type="image/png" href="./img/logo.png" />
    <link rel="stylesheet" href="./default.css" />
    <!--Para mostrar o listar-->
    <link rel="stylesheet" href="./design/crud/read_delete.css" />
    <script type="text/javascript" src="./vendor/SC/RDserver.js"></script>
    <script>
      <c:if test="${com!=''&&data!=''&&data!=null}">
      let rd = new RDserver();//preparar
      rd.setUrl("${com}");
      let data = ${data};
      rd.setSelect(data.select);
      rd.setSons(data.sons);
      rd.setColumns(data.columns);
      rd.setUpdate(new Date(Number(data.date) * 1000));
      if (data.fdate !== undefined) {
        rd.setFirdate(Number(data.fdate) / 1000);
      }
      </c:if>
    </script>
  </head>
  <body>
    <div class="scc_noselec" id="Vrede" v-if="JHplugin">
      <header class="w3-container w3-sand w3-bar">
        <button
          class="w3-bar-item w3-button w3-hover-sepia jh3-navi"
          v-for="who in whos.left"
          v-bind:class="[who.act?'w3-yellow':'']"
          v-bind:data-key="who.key"
        >
          <i class="fas fa-fw" v-bind:class="who.ico"></i> {{ who.txt }}
        </button>
        <button class="w3-bar-item w3-button w3-right" id="cnf">
          <i class="fas fa-cogs"></i>
        </button>
        <button
          v-for="who in whos.right"
          class="w3-bar-item w3-button w3-right w3-ripple jh3-navir"
          v-bind:class="[who.typ==='maps'?'w3-hover-teal':who.typ==='whap'?'w3-hover-green':who.typ==='emil'?'w3-hover-red':who.typ==='face'?'w3-hover-blue':'']"
          v-bind:data-key="who.key"
          v-bind:data-type="who.typ"
          v-bind:title="[who.typ==='maps'?'Ir a maps':who.typ==='whap'?'Abrir en Whatsapp':who.typ==='emil'?'Abrir en email':who.typ==='face'?'Abrir con facebook messenger':'']"
        >
          <i
            v-bind:class="[who.typ==='maps'?'fas fa-map-marker-alt':who.typ==='whap'?'fab fa-whatsapp':who.typ==='emil'?'fas fa-at':who.typ==='face'?'fab fa-facebook-messenger':'']"
          ></i>
        </button>
      </header>
      <div class="w3-container w3-white w3-responsive">
        <div
          id="select"
          v-if="select.juti.length>0||select.ups.length>0"
          class="w3-bar w3-light-blue w3-section w3-disabled"
        >
          <button
            v-for="opt in select.juti"
            v-bind:data-key="opt.key"
            v-bind:data-nvl="opt.mod"
            class="w3-button w3-bar-item w3-ripple s3"
            v-bind:class="[opt.ali ? 'w3-left' : 'w3-right']"
            v-bind:title="'Click para: '+opt.txt"
          >
            <i class="fas" v-bind:class="opt.ico"></i>
            <span>{{ opt.txt }}</span>
          </button>
          <div
            class="w3-dropdown-hover"
            v-bind:class="[opt.ali ? 'w3-right' : 'w3-left']"
            v-for="opt in select.ups"
          >
            <button class="w3-button" v-bind:data-key="opt.key">
              <i class="fa fa-fw fa-bolt"></i> <span>{{ opt.txt }}</span>
            </button>
            <div class="w3-dropdown-content w3-bar-block w3-card-4">
              <button
                class="w3-bar-item w3-button"
                v-for="st in opt.vls"
                v-bind:data-key="st.key"
              >
                <i class="fas fa-angle-double-right w3-tiny"></i>
                <span>{{ st.txt }}</span>
              </button>
            </div>
          </div>
        </div>
        <table
          id="DTelems"
          class="w3-table-all"
          style="width: 100%"
          v-if="titles.length>0"
        >
          <thead>
            <tr>
              <th v-for="title in titles">
                <button
                  class="w3-button w3-border w3-round-medium w3-hoverable w3-hover-blue w3-tiny w3-padding-small"
                  title="Click para seleccionar todo"
                  v-if="title.isSel"
                >
                  <i class="fa fa-fw fa-plus"></i>
                </button>
                <span v-else-if="title.isDet"></span>
                <span v-else>{{ title.txt }}</span>
              </th>
            </tr>
          </thead>
          <tfoot>
            <tr>
              <th v-for="title in titles">
                <input
                  style="font-weight: normal"
                  class="jh-inp jh-inpp"
                  type="text"
                  v-bind:placeholder="'Buscar en '+title.txt"
                  title="Introdusca para buscar"
                  v-if="title.fotserch||title.filters!=undefined"
                  v-bind:list="[title.filters!=undefined?title.txt:'']"
                />
                <button
                  class="jh-btn"
                  type="button"
                  title="Click para limpiar busqueda"
                  v-if="title.fotserch"
                >
                  <i class="fas fa-times-circle"></i>
                </button>

                <button
                  class="w3-button w3-border w3-round-medium w3-hoverable w3-hover-blue w3-tiny w3-padding-small"
                  title="Click para remover lo releccionado"
                  v-else-if="title.isSel"
                  disabled="true"
                >
                  <i class="fa fa-fw fa-minus"></i>
                </button>
                <span v-else-if="title.isDet"></span>
                <datalist
                  v-else-if="title.filters!=undefined"
                  v-bind:id="title.txt"
                >
                  <option
                    v-for="filter in title.filters"
                    v-bind:value="filter.key"
                  >
                    {{ filter.txt }}
                  </option>
                </datalist>
                <input
                  style="font-weight: normal"
                  class="jh-inp filDate_Box"
                  type="text"
                  v-else-if="title.isDate==true"
                  v-bind:data-key="title.name"
                  v-bind:placeholder="'Buscar en '+title.txt"
                  readonly
                />
                <span v-else>{{ title.txt }}</span>
              </th>
            </tr>
          </tfoot>
        </table>
      </div>
      <footer class="w3-container w3-light-gray">
        <p style="font-size: 10pt" class="w3-opacity">
          Actualizado el {{ upDate }}
        </p>
      </footer>
    </div>
    <script
      type="text/javascript"
      src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.6.11/vue.min.js"
    ></script>
    <script
      type="text/javascript"
      src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"
    ></script>
    <script type="module" src="./design/crud/read_delete.js"></script>
  </body>
</html>
