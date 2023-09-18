import { filterBox } from "./../../vendor/SC/JIII-Plu-0.2/js/FilterBox.js";
import { filterDBox } from "./../../vendor/SC/JIII-Plu-0.2/js/FilterDateBox.js";
import { select } from "./../../vendor/SC/JIII-Plu-0.2/js/Select.js";
import { detail } from "./../../vendor/SC/JIII-Plu-0.2/js/Detail.js";
$(document).ready(function () {
  //Vue, inizilizacion
  if (typeof rd !== "undefined") {
    // console.log(rd.getVue_Titles());
    new Vue({
      el: "#Vrede",
      data: {
        JHplugin: true,
        whos: rd.getSons(),
        upDate: rd.getUpdate(), //Incluso si las demas crud no impliquen recargar, este será la que se obtenga al recargar?...
        select: rd.getSelect(),
        titles: rd.getVue_Titles(),
      },
    });
    //DataTable, inizilizacion
    // TODO Fix import
    $.getScript(
      "https://cdn.datatables.net/v/dt/jq-3.3.1/dt-1.10.20/sl-1.3.1/datatables.min.js",
      function () {
        $.fn.dataTable.ext.classes.sPageButton =
          "w3-button w3-hover-teal w3-round-small w3-ripple";
        $.fn.dataTable.ext.classes.sPageButtonDisabled = "w3-disabled";
        $.fn.dataTable.ext.classes.sPageButtonActive = "w3-teal";
        let table = $("#DTelems").DataTable({
          processing: true,
          serverSide: true,
          pageLength: 12,
          ajax: {
            url: rd.getURL(),
            type: "POST", // dataType: "jsonp",
            data: function (d) {
              d.who = rd.getSon();
            },
          },
          columns: rd.getDT(),
          dom: '<"w3-row w3-section"<"w3-col s12"rt>>" + "<"w3-row w3-section"<"w3-col s4"i><"w3-col s8 w3-container w3-bar"p>>',
          order: rd.getOrder(),
          language: {
            lengthMenu: "_MENU_ registros", //usado?
            zeroRecords: "Ningun registro obtenido",
            info: "Obtenido: _TOTAL_ registros", //? Viendo: _START_ a _END_ de _TOTAL_ registros obtenidos,
            infoEmpty: "Obtenido: 0 registros", //usado?
            infoFiltered: "entre _MAX_ registros",
            processing:
              '<i class="fa fa-spinner fa-spin fa-3x fa-fw"></i> Cargando...',
            paginate: {
              next: "<b>&#x276f;</b>",
              previous: "<b>&#x276e;</b>",
            },
            select: {
              rows: {
                _: "Seleccionó <b>%d</b> filas",
                0: "",
                1: "Seleccionó <b>1</b> fila",
              },
            },
          },
          select: {
            style: "multi",
            selector: "td:nth-child(" + (rd.getSelectCol() + 1) + ")", //pues no cuenta desde 0
            className: "selected w3-pale-blue", //table-primary fixFila
          },
          footerCallback: function (row, data, start, end, display) {
            if (rd.getTotals().length > 0) {
              let ap = this.api();
              let arr = rd.getTotals();
              for (let i = 0; i < arr.length; i++) {
                let pt = ap
                  .column(arr[i], { page: "current" })
                  .data()
                  .reduce(function (a, b) {
                    return parseFloat(a) + parseFloat(b);
                  }, 0);
                // Update footer
                $(ap.column(arr[i]).footer()).html("Bs. " + pt);
              }
            }
          },
          searchCols: rd.getDefls(),
          initComplete: function () {
            parent.resizeIframe("myiframe"); //aveces si aveces no
          },
        });
        filterBox(table, rd);
        filterDBox(table, rd);
        select(table, rd);
        detail(table, rd);
        table.on("draw.dt", function () {
          parent.resizeIframe("myiframe");
        });
      }
    );
  } else {
    new Vue({
      el: "#Vrede",
      data: {
        JHplugin: false,
      },
    });
  }
});
