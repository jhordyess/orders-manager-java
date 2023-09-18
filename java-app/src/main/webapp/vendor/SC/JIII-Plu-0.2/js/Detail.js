export { detail };
/**
 * Habilita el muestreo de datos extra debajo una fila. Consulta al servidor.
 * @param {DataTable} table - Objeto en datatable.js referenciado a una tabla.
 * @param {RDServer} inst - Objeto de RDServer.js referenciado.
 * */
function detail(table, inst) {
  if (inst.chkDetail()) {
    //var curtis = $(this);

    /**Cerrar todo...*/
    function iResAll() {
      var sd = $("table#DTelems tbody tr td.jh-dtl");
      $.each(sd, function () {
        if ($(this).hasClass("jh-dtlO")) {
          $(this).removeClass("jh-dtlO");
        }
        if (!$(this).hasClass("jh-dtlC")) {
          $(this).addClass("jh-dtlC");
        }
        //
      });
    }
    /**Para cambiar dinamicamente el iconos.
     * @param {Boolean} sw
     * @param {JQery} cura - Objeto jquery*/
    function iOpCl(sw, cura) {
      if (sw) {
        cura.removeClass("jh-dtlC");
        cura.addClass("jh-dtlO");
      } else {
        cura.removeClass("jh-dtlO");
        cura.addClass("jh-dtlC");
      }
    }
    /**Consulta a servidor y mostrar la respuesta correspondiente.
     * @param {Undefined} val - description.
     * @param {DTRow} row - Fila actual.*/
    function senSho(val, row) {
      $.ajax({
        //dataType: "json",
        method: "POST",
        url: inst.getURL(),
        data: {
          tt: inst.getAuth(),
          id: val,
        },
        success: function (data, textStatus, jqXHR) {
          row.child(compn(data), "jh-rowI w3-border-amber").show(); //Puede ir otras clase
        },
        error: function (jqXHR, textStatus, errorThrown) {
          row.child(jqXHR).show();
        },
      });
    }
    /**
     * Cuando se hace click, verifia si existe o no para mostrarse o no.*/
    $(document).on("click", "table#DTelems tbody tr td.jh-dtl", function () {
      var tr = $(this).closest("tr");
      var row = table.row(tr);
      if (row.child.isShown()) {
        tr.removeClass("w3-amber w3-sepia-max");
        iOpCl(false, $(this));
        row.child.hide();
      } else {
        tr.addClass("w3-amber w3-sepia-max");
        iOpCl(true, $(this));
        var indes = -1; //tr.children('td').eq(2)[0].textContent;//ojito
        senSho(indes, row);
      }
    });
    /**Componer.
     * @param {JSON} data Valores*/
    function compn(data) {
      var temp = "<div class='w3-cell-row w3-white'>";
      $.each(data, function (tip, val) {
        temp += "<div class='w3-container w3-cell w3-cell-middle'>";
        if (typeof tip !== "undefined" && typeof val !== "undefined") {
          //puede usarse sin type of...
          switch (tip) {
            case "tnxm": //tabla n x m
              temp += "<table class='w3-table-all'>" + "<thead>" + "<tr>";
              $.each(val.head, function (key, val) {
                temp += "<th>" + val + "</th>";
              });
              temp += "</tr>" + "</thead><tbody>";
              $.each(val.data, function (key, row) {
                temp += "<tr>";
                $.each(row, function (key, val) {
                  temp += "<td>" + val + "</td>";
                });
                temp += "</tr>";
              });
              temp += "</tbody>" + "</table>";
              break;
            case "t1xn": //tabla 1 x n
              temp += "<table class='w3-table-all'>" + "<thead>" + "<tr>";
              $.each(val.data, function (nam, val) {
                temp += "<th>" + nam + "</th>";
              });
              temp += "</tr>" + "</thead><tbody>" + "<tr>";
              $.each(val.data, function (nam, val) {
                temp += "<td>" + val + "</td>";
              });
              temp += "</tr>" + "</tbody>" + "</table>";
              break;
            case "vals": //valores sencillos
              temp += "<dl>";
              $.each(val.data, function (nam, val) {
                temp += "<dt>" + nam + "</dt>";
                temp += "<dd>" + val + "</dd>";
              });
              temp += "</dl>";
              break;
            case "scake": //estadisticos caake
              break;
            default:
              temp += "Tipo no soportado";
              break;
          }
        } else {
          temp += "Valores no soportados";
        }
        temp += "</div>";
      });
      temp += "</div>";
      return temp;
    }
  }
}
