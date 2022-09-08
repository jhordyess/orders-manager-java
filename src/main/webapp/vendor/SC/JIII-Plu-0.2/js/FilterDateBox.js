export { filterDBox };
/**
 * Funcion para emplear filtros por fecha.
 * @param table El objeto en datatable referenciado a una tabla.
 * @param inst objeto de RDServer.
 * */
function filterDBox(table, inst) {
  if (inst.chkDFilters()) {
    // TODO Fix import
    $.getScript(
      "https://cdnjs.cloudflare.com/ajax/libs/bootstrap-daterangepicker/3.0.5/moment.min.js",
      function () {
        var elem = $("table#DTelems tfoot tr th");
        $.getScript(
          "https://cdnjs.cloudflare.com/ajax/libs/bootstrap-daterangepicker/3.0.5/daterangepicker.min.js",
          function () {
            /**Configuracion para el calendario*/
            $.each(elem.find("input.filDate_Box"), function () {
              $(this).daterangepicker({
                //'autoApply': true,
                autoUpdateInput: false,
                showCustomRangeLabel: false,
                showDropdowns: true,
                alwaysShowCalendars: true,
                minDate: moment.unix(inst.getFecha_ini()),
                opens: "left",
                drops: "up",
                buttonClasses: "w3-button w3-small",
                applyButtonClasses: "w3-blue w3-hover-teal",
                cancelClass: "w3-white w3-hover-gray",
                locale: {
                  format: "MM/DD/YYYY",
                  daysOfWeek: ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sa"],
                  monthNames: inst.getMess(),
                  firstDay: 0,
                  applyLabel: "Aceptar",
                  cancelLabel: "Cancelar",
                },
                ranges: {
                  Hoy: [moment(), moment()],
                  Ayer: [
                    moment().subtract(1, "days"),
                    moment().subtract(1, "days"),
                  ],
                  "&Uacute;ltimos 7 dias": [
                    moment().subtract(6, "days"),
                    moment(),
                  ],
                  "&Uacute;ltimos 30 dias": [
                    moment().subtract(29, "days"),
                    moment(),
                  ],
                  "&Eacute;ste mes": [
                    moment().startOf("month"),
                    moment().endOf("month"),
                  ],
                  "Mes pasado": [
                    moment().subtract(1, "month").startOf("month"),
                    moment().subtract(1, "month").endOf("month"),
                  ],
                  "Año pasado": [
                    moment().subtract(1, "year").startOf("year"),
                    moment().subtract(1, "year").endOf("year"),
                  ],
                },
              });
              $(this).on("apply.daterangepicker", function (ev, picker) {
                table
                  .columns($(this).attr("data-key") + ":name")
                  .search(
                    picker.startDate.unix() + "&&" + picker.endDate.unix()
                  )
                  .draw();
                var ini =
                  picker.startDate.get("D").toString() +
                  " " +
                  inst.getSMes(picker.startDate.get("M")).substring(0, 3) +
                  ". " +
                  picker.startDate.get("Y");
                var fin =
                  picker.endDate.get("D").toString() +
                  " " +
                  inst.getSMes(picker.endDate.get("M")).substring(0, 3) +
                  ". " +
                  picker.endDate.get("Y");
                $(this).val(ini + " - " + fin);
              });
              $(this).on("cancel.daterangepicker", function (ev, picker) {
                table
                  .columns($(this).attr("data-key") + ":name")
                  .search("")
                  .draw();
                $(this).val("");
              });
            });
          }
        );
      }
    );
  }
}
