class Defserver {
  constructor() {
    this.menu = [{}];
    var that = this;
    this.setView = function () {
      return $.ajax({
        //async: true,
        dataType: "json",
        method: "POST",
        url: "http://localhost:8080/main",
        data: {
          mm: "",
        },
        beforeSend: function () {
          //poner imagen cargando
        },
      })
        .always(function () {
          //remover cargando
        })
        .done(function (data) {
          that.menu = data.menu;
        })
        .fail(function () {});
    };
  }
  getMenu() {
    return this.menu;
  }
  /**
   * Obtener el primer activo, solo al inicio*/
  /*getFiCurr() {
    let out = undefined;
    for (let i = 0; i < this.menu.length; i++) {
      if (this.menu[i].hasOwnProperty("isAct")) {
        if (this.menu[i].isAct) {
          
        }
      }
    }
    return out;
  }*/
}
