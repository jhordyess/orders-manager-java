startTime();
/*Configuracion para el menu*/
var mySidebar = document.getElementById("myMenu");
var overlayBg = document.getElementById("myMBtn");
function w3_open() {
  if (mySidebar.style.display === "block") {
    mySidebar.style.display = "none";
    overlayBg.style.display = "none";
  } else {
    mySidebar.style.display = "block";
    overlayBg.style.display = "block";
  }
}
function w3_close() {
  mySidebar.style.display = "none";
  overlayBg.style.display = "none";
}
$(document).ready(function () {
  /*Menu y acceso*/
  // TODO Fix import
  $.getScript("./vendor/SC/Defserver.js", function () {
    let xp = new Defserver();
    xp.setView().done(function () {
      var jhMenu = new Vue({
        el: "#Vmenu",
        data: {
          message: "Raro",
          usr: {
            name: "Jhordy",
          },
          menus: xp.getMenu(),
        },
      });
      let bool;
      $(document).on("click", "a.jh-link", function () {
        //hace antes de cambiar link..
        var tmp = $(this).children("span").text();
        bool = false;
        $.each(jhMenu.menus, function () {
          if (this.txt === tmp) {
            if (!this.isMod) {
              //closeModal();
              this.isAct = true;
              $("body div.w3-main > header.w3-container > h4 span").text(
                this.txt
              );
            } else {
              setModal(0, this.link);
              //console.log("$('div#mdl div footer button#mdl_acc')");
              bool = true;
              return false; //break
            }
          }
        });
        $.each(jhMenu.menus, function () {
          if (this.txt !== tmp && !bool) {
            this.isAct = false;
          }
        });
      });
      $(document).on(
        "mousedown",
        "div#mdl div footer button#mdl_acc",
        function () {
          if (bool) {
            try {
              let xd = document
                .getElementById("myMFrame")
                .contentWindow.lastval();
              if (xd) {
                let sd = document
                  .getElementById("myMFrame")
                  .contentWindow.save();
                let com = document
                  .getElementById("myMFrame")
                  .contentWindow.getCom();
                let sera = document
                  .getElementById("myMFrame")
                  .contentWindow.getpaRecibo();
                senderar(com, sd, sera);
              } else {
                alert("No puede continuar");
              }
            } catch (e) {
              //significa que no tiene lo anterior
              //table.rows({search: 'applied'}).deselect();
              //parent.closeModal();
              // BUG
              console.log(e);
            }
          }
        }
      );
      $(document).on(
        "mousedown",
        "div#mdl div header button#mdl_xout",
        function () {
          if (bool) {
            bool = false;
          }
        }
      );
    });
  });
});

/***/
var modals = new Vue({
  el: "#Vmdl",
  data: {
    title: -1,
    msg: "",
    elems: [],
  },
  updated: function () {
    this.$nextTick(function () {
      chavelo();
      chilis();
    });
  },
});
/**Funcion para mostrar modal.
 * @param {Integer} nvl - Nivel del modal, aceptado 0 a 2.
 * @param {String} msg - Mensaje de modal.
 * @param {Object} list - Posible valor para input.
 * */
function setModal(nvl, msg, list) {
  modals.title = nvl;
  modals.msg = msg; //La accion fue llevada a cabo.
  if (list !== undefined) {
    modals.elems = list;
  }
  showModal(); //propio de modal
}
/**Funcion para ocultar modal.*/
function closeModal() {
  modals.title = -1;
  modals.msg = "";
  modals.elems = [];
  hideModal(); //propio de modal
  redoTab(); //
}
///-- FUncion para el envio de pedido
function senderar(com, sd, sera) {
  $.ajax({
    method: "POST",
    url: com,
    data: {
      tt: "123",
      ky: "CUP",
      dd: JSON.stringify(sd),
    },
    beforeSend: function () {
      parent.mdlSend();
    },
    success: function (result) {
      if (result.sw === 0) {
        alert("Error: " + result.msg);
        mdlRedo();
      } else {
        if (sera) {
          window.open("./LaTeX?t=" + result.recc + "&s=1#zoom=150", "_BLANK"); //recibo
        }
        bool = false;
        window.setTimeout(function () {
          try {
            document
              .getElementById("myiframe")
              .contentWindow.$("#DTelems")
              .DataTable()
              .ajax.reload(null, false); //table.ajax.reload(null, false); //table.draw
          } catch (e) {}
        }, 250);
        closeModal();
      }
    },
  });
}
