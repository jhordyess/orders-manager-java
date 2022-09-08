export { select };
/**
 * Habilita la seleccion, mostrando deltante del div y encima de la tabla.
 * @param {DataTable} table - Objeto en datatable.js referenciado a una tabla.
 * @param {RDServer} inst - Objeto de RDServer.js referenciado.
 * */
function select(table, inst) {
  if (inst.chkSelect()) {
    /**
     * Ubicacion de los botones para seleccionar todo o nada. Tambien se formatea el div que se aparecera encima tabla.
     * */
    let divselect = $("div#select");
    let todoB = $("table#DTelems thead tr th.select-checkbox button"); //Cuidado
    let nadaB = $("table#DTelems tfoot tr th.select-checkbox button"); //Cuidado
    /**
     * Cuando se seleccione o no en la tabla
     * */
    table
      .on("select", function () {
        changing();
      })
      .on("deselect", function () {
        changing();
      });
    /**
     * Cuando se haga click en el boton todoB.
     * */
    todoB.click(function () {
      table.rows({ search: "applied" }).select();
    });
    /**
     * Cuando se haga click en el boton nadaB.
     * */
    nadaB.click(function () {
      table.rows({ search: "applied" }).deselect();
    });
    /**
     * Desabilita o no los elementos de pie con input y su boton.
     * @param {Boolean} sw
     * */
    function lockFoot(sw) {
      var tt = $("table#DTelems tfoot tr th input.jh-inp");
      var ss = $("table#DTelems tfoot tr th button.jh-btn");
      if (sw !== tt.prop("disabled")) {
        if (sw) {
          //blockear
          tt.prop("disabled", true);
          tt.addClass("w3-disabled");
          ss.hide();
        } else {
          tt.prop("disabled", false);
          tt.removeClass("w3-disabled");
          ss.show();
        }
      }
    }
    function divsState(sw) {
      if (/*sw !== */ divselect.is(":visible")) {
        if (sw) {
          //mostrar
          divselect.removeClass("w3-disabled");
          //divselect.fadeIn(300);
        } else {
          //ocultar
          divselect.addClass("w3-disabled");
          //divselect.fadeOut(300);
        }
      }
    }
    /**
     * Funcion que oculta o muestra a los botones dinamicamente.
     * */
    function changing() {
      var ux = getSelected().length;
      var sm = table.rows({ search: "applied" }).data().toArray().length; //optimizable
      if (ux > 0) {
        divsState(true);
        nadaB.prop("disabled", false);
        lockFoot(true);
      } else {
        divsState(false);
        nadaB.prop("disabled", true);
        lockFoot(false);
      }
      if (ux === sm) {
        //Si uno esta condicion a mas arriba...podria crear otra funcion para la muestra o no de los botones
        todoB.prop("disabled", true);
      } else {
        todoB.prop("disabled", false);
      }
    }
    /**
     * Funcion que oculta los botones.;
     * */
    function hiddens() {
      divsState(false);
      lockFoot(false);
      todoB.prop("disabled", false);
      if (!nadaB.prop("disabled")) {
        nadaB.prop("disabled", true);
      }
    }
    /**
     * Obtener un Arreglo de los objetos seleccionados*/
    function getSelected() {
      //return table.rows({selected: true}).ids().toArray().length;
      return table.rows(".selected").data().toArray();
    }
    /**
     * */
    function madeforSend() {
      let xd = [];
      let x = inst.getIniempty();
      let arr = getSelected();
      arr.forEach((v) => {
        xd.push(v[x]);
      });
      return JSON.stringify(xd);
    }
    /**Cuando hace una busqueda. Necesario si el scrollbar se esconde...*/
    table.on("search.dt", function () {
      hiddens();
    });
    /**Cuando cambia de pagina*/
    table.on("page.dt", function () {
      hiddens();
      parent.resizeIframe("myiframe");
    });
    /**/
    let key = undefined;
    let mlvl = -1;
    let me = false;
    /*Cuando se clickee un boton...*/
    $(document).on("click", "div#select button", function () {
      me = true;
      key = $(this).attr("data-key"); //send key...
      mlvl = Number($(this).attr("data-nvl"));
      if (mlvl === 0) {
        getIt(key).done(function (data) {
          if (data.msg !== "") {
            parent.setModal(0, data.msg);
          }
        });
      } else if (mlvl === 1) {
        //NO mostrar si su cokkie no corresponde..., asi directamente se hace
        //cuidado con lo de close y el valor de key
        //servlet();
        parent.setModal(
          1,
          'Debe confirmar para: "' +
            $(this).find("span").text() +
            '" lo seleccionado.'
        );
      } else if (mlvl === 2) {
        parent.setModal(
          2,
          'Debe confirmar: "' +
            $(this).find("span").text() +
            '" lo seleccionado.'
        );
      } else if (mlvl === 3) {
        getIt(key).done(function (data) {
          parent.setModal(3, data.msg, data.arr);
        });
      } /*else if(){ //var option = $(this).find('span').text();
       getEdo().done(function (data) {
       parent.setModal(3, data);
       });
       }*/
    });
    /*Si es movimiento de algun filtro activo*/
    $(document).on("click", "div#select > div > div > button", function () {
      let bro = $(this).parent().prev();
      me = true;
      key = bro.attr("data-key"); //send key...
      mlvl = $(this).attr("data-key") + "";
      parent.setModal(
        1,
        'Debe confirmar para: "' +
          bro.find("span").text() +
          " a " +
          $(this).find("span").text() +
          '" lo seleccionado.'
      );
    });
    $(parent.document).on(
      "mousedown",
      "div#mdl div footer button#mdl_acc",
      function () {
        if (me) {
          var sw;
          if (mlvl === 0) {
            try {
              let xd = parent.document
                .getElementById("myMFrame")
                .contentWindow.lastval();
              if (xd) {
                let sd = parent.document
                  .getElementById("myMFrame")
                  .contentWindow.save();
                let com = parent.document
                  .getElementById("myMFrame")
                  .contentWindow.getCom();
                Sendo(sd, com);
                /*parent.mdlSend();      // En windows el comando xhttp.open , codifica la url, y el json.stringfly que contiene comillas, las pone con %22, entoncet el servidor TOMCAT no las acepta provocando un error en este Servidor.
               let xhttp = new XMLHttpRequest();
               xhttp.onreadystatechange = function (ed) {
               if (this.readyState === 4 && this.status === 200) {
               let result = JSON.parse(this.responseText);
               parent.closeModal();
               if (result.sw === 0) {
               alert("Error: " + result.msg);
               }
               window.setTimeout(function () {
               table.ajax.reload(null, false); //table.draw
               }, 250);
               varclen();
               }
               };
               xhttp.open("POST", com + "?tt=123&ky=CUP&dd=" + JSON.stringify(sd), true);
               xhttp.send();*/
              } else {
                alert("No puede continuar");
              }
            } catch (e) {
              //significa que no tiene lo anterior
              varclen();
              table.rows({ search: "applied" }).deselect();
              parent.closeModal();
            }
          } else if (mlvl === 1) {
            sw = parent.document.getElementById("mdl_chk").checked;
            //hacer su cookie
            servlet();
          }
          if (mlvl === 2) {
            servlet();
          } else if (mlvl === 3 || mlvl === 4) {
            if (parent.valIns()) {
              servlet();
            } else {
              alert("No puede continuar");
            }
          } else if (typeof mlvl === "string") {
            servlet();
          }
        }
      }
    );
    $(parent.document).on(
      "mousedown",
      "div#mdl div footer button#mdl_out",
      function () {
        if (me) {
          varclen();
          table.rows({ search: "applied" }).deselect();
        }
      }
    );
    $(parent.document).on(
      "mousedown",
      "div#mdl div header button#mdl_xout",
      function () {
        if (me) {
          varclen();
          table.rows({ search: "applied" }).deselect();
        }
      }
    );
    function varclen() {
      key = undefined;
      mlvl = -1;
      me = false;
    }
    function servlet() {
      let ap = {
        dt: madeforSend(),
      };
      if (typeof mlvl === "string") {
        ap.ot = mlvl;
      }
      if (mlvl === 3 || mlvl === 4) {
        ap.vl = parent.getIns();
      }
      /**/
      let das = {
        tt: inst.getAuth(),
        ky: key,
        dd: JSON.stringify(ap),
      };
      $.ajax({
        method: "POST",
        url: inst.getURL(),
        data: das,
        beforeSend: function () {
          parent.mdlSend();
        },
        success: function (result) {
          parent.closeModal();
          if (result.sw === 0) {
            alert("Error: " + result.msg);
          } /* else{
           console.log(result);
           }*/
          // let page = table.page.info().page;
          window.setTimeout(function () {
            table.ajax.reload(null, false); //table.draw
          }, 250);
          varclen();
        },
      });
    }
    function getIt() {
      return $.ajax({
        method: "POST",
        url: inst.getURL(),
        data: {
          tt: inst.getAuth(),
          ky: key,
          ds: madeforSend(),
        },
      });
    }
    $("div#Vrede header button.jh3-navi").on("click", function (e) {
      let tmp = $(this).attr("data-key");
      if (tmp === "NEO") {
        me = true;
        key = tmp;
        mlvl = 4;
        table.rows({ search: "applied" }).deselect();
        getIt().done(function (data) {
          parent.setModal(4, data.msg, data.arr);
        });
      } else {
        window.open(inst.getURL() + "?nav=" + tmp, "_self");
      }
    });
    $("div#Vrede header button.jh3-navir").on("click", function (e) {
      let tmp = $(this).attr("data-key");
      let tpe = $(this).attr("data-type").toString();
      if (tmp !== "" && tmp !== undefined) {
        if (getSelected().length === 1) {
          getWas(tmp)
            .done(function (data) {
              switch (tpe) {
                case "whap":
                  try {
                    if (
                      (data.npm.length === 8) &
                      (data.npm.charAt(0) === "7" || data.npm.charAt(0) === "6")
                    ) {
                      window.open(
                        "https://wa.me/" + Number(data.npm) + "",
                        "_blank"
                      );
                    }
                  } catch (e) {}
                  break;
                case "face": //
                  try {
                    let str = data.npm.toString();
                    if (str.length !== 0 && str.match(/^[a-z\d.]{5,}$/i)) {
                      window.open("https://m.me/" + str + "", "_blank");
                    }
                  } catch (e) {}
                  break;
                case "maps":
                  try {
                    let str = data.npm.toString();
                    if (str.length !== 0) {
                      window.open(
                        "https://www.google.com/maps/search/?api=1&query=" +
                          str +
                          "",
                        "_blank"
                      );
                    }
                  } catch (e) {}
                  break;
                case "emil":
                  try {
                    let str = data.npm.toString();
                    if (
                      str.length !== 0 &&
                      str.match(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/)
                    ) {
                      window.open("mailto:" + str + "", "_blank");
                    }
                  } catch (e) {}
                  break;
              }
            })
            .fail(function (data) {
              //console.log(data);
            });
        }
      }
    });
    function getWas(hd) {
      return $.ajax({
        method: "POST",
        url: inst.getURL(),
        data: {
          tt: inst.getAuth(),
          ky: hd,
          ds: madeforSend(),
        },
      });
    }
    function Sendo(sd, com) {
      $.ajax({
        method: "POST",
        url: com,
        data: {
          tt: inst.getAuth(),
          ky: "CUP",
          dd: JSON.stringify(sd),
        },
        beforeSend: function () {
          parent.mdlSend();
        },
        success: function (result) {
          parent.closeModal();
          if (result.sw === 0) {
            alert("Error: " + result.msg);
          }
          window.setTimeout(function () {
            table.ajax.reload(null, false); //table.draw
          }, 250);
          varclen();
        },
      });
    }
  }
}
