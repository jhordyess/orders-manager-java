export { filterBox };
/**
 * Funcion para usar las busquedas por combobox, y/o de pie de tabla.
 * @param {DataTable} table - Objeto en datatable.js referenciado a una tabla.
 * @param {RDServer} inst - Objeto de RDServer.js referenciado.
 * */
function filterBox(table, inst) {
  if (inst.chkFFilters()) {
    table.columns().every(function () {
      var that = this;
      $("input.jh-inpp", this.footer()).on("input", function () {
        //input
        let sw = true;
        $(this)
          .parent()
          .children("input.jh-inp")
          .val(
            this.value.replace(/[^a-zA-Z0-9- ]/g, function () {
              //otro metodo para mejorar performanze?
              alert("No se admiten caracteres especiales");
              sw = false;
              return "";
            })
          );
        if (that.search() !== this.value && !this.value.includes("&&") && sw) {
          that.search(this.value).draw();
        }
      });
      $("input", this.footer()).on("keyup", function (e) {
        if (e.keyCode === 27) {
          that.search("").draw();
          $(this).parent().children("input.jh-inp").val("");
          $(this).parent().children("input.jh-inp").blur();
        }
      });
      $("button.jh-btn", this.footer()).on("click", function () {
        if ($(this).parent().children("input.jh-inp").val() !== "") {
          that.search("").draw();
          $(this).parent().children("input.jh-inp").val("");
        }
      });
    });
  }
  /*table.on('page.dt', function () {
   $('input.jh-inp').val("");
   });*/
}
