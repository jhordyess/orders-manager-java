class RDserver {
  constructor() {
    this.meses = new Array(
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre"
    ); //podria depender de otra clase de configuracion
    this.url = "null";
    this.update = new Date();
    this.firdate = undefined;
    this.columns = [{}];
    this.select = { juti: [{}], ups: [{}] };
    this.sons = { left: [{}], right: [{}] };
  }
  setUrl(e) {
    this.url = e;
  }
  setUpdate(e) {
    this.update = e;
  }
  setFirdate(e) {
    this.firdate = e;
  }
  setColumns(e) {
    this.columns = e;
  }
  setSelect(e) {
    this.select = e;
  }
  setSons(e) {
    this.sons = e;
  }

  /**Obtener un Arreglo de objetos para usar DataTables.js unicamente para iniciar su configuracion.
   * @return {Array} Conjunto de objetos.*/
  getDT() {
    let out = new Array();
    for (let i = 0; i < this.columns.length; i++) {
      let tmp = this.columns[i].dt;
      if (this.columns[i].hasOwnProperty("type")) {
        if (this.columns[i].type === "sw") {
          //configuracion para mostrar en la tabla los que son de tipo SW.
          tmp.createdCell = function (td, cellData, rowData, row, col) {
            $(td).html("");
            if (cellData === "0") {
              $(td).addClass("jh-sw0");
            } else if (cellData === "1") {
              $(td).addClass("jh-sw1");
            }
          };
        } else if (this.columns[i].type === "sus") {
          tmp.createdCell = function (td, cellData, rowData, row, col) {
            $(td).html("Bs. " + cellData);
            if (cellData === "0") {
              $(td).css("color", "red");
            }
          };
        } else if (this.columns[i].type === "gen") {
          //configuracion para mostrar en la tabla los que son de tipo GENERO
          tmp.createdCell = function (td, cellData, rowData, row, col) {
            $(td).html("");
            if (cellData === "0") {
              $(td).addClass("jh-ge0");
            } else if (cellData === "1") {
              $(td).addClass("jh-ge1");
            } else if (cellData === "2") {
              $(td).addClass("jh-ge2");
            }
          };
        } else if (this.columns[i].type === "jh1") {
          tmp.createdCell = function (td, cellData, rowData, row, col) {
            var z = "";
            $(td).addClass("jh-sc1");
            if (cellData === "0") {
              $(td).addClass("jh-sc10");
              z = "Evento";
            } else if (cellData === "1") {
              $(td).addClass("jh-sc11");
              z = "Distibuidor";
            } else if (cellData === "2") {
              $(td).addClass("jh-sc12");
              z = "Normal";
            } else if (cellData === "3") {
              $(td).addClass("jh-sc13");
              z = "Normal de evento";
            } else if (cellData === "4") {
              $(td).addClass("jh-sc14");
              z = "Normal de distribuidor";
            }
            $(td).html("<div title='" + z + "'>" + z + "</div>");
          };
        } else if (this.columns[i].type === "jh2") {
          tmp.createdCell = function (td, cellData, rowData, row, col) {
            var z = "";
            $(td).addClass("jh-sc2");
            if (cellData === "1") {
              $(td).addClass("jh-sc21");
              z = "Entrante";
            } else if (cellData === "2") {
              $(td).addClass("jh-sc22");
              z = "Aprobado";
            } else if (cellData === "3") {
              $(td).addClass("jh-sc23");
              z = "Rechazado";
            } else if (cellData === "4") {
              $(td).addClass("jh-sc24");
              z = "Terminado";
            } else if (cellData === "5") {
              $(td).addClass("jh-sc25");
              z = "Enviado";
            } else if (cellData === "6") {
              $(td).addClass("jh-sc26");
              z = "Cancelado";
            }
            $(td).html("<div title='" + z + "'>" + z + "</div>");
          };
        } else if (this.columns[i].type === "date") {
          let meses = this.meses;
          tmp.createdCell = function (td, cellData, rowData, row, col) {
            let date = new Date(Number(cellData) * 1000);
            $(td).html(
              date.getDate() +
                " " +
                meses[date.getMonth()] +
                " " +
                date.getFullYear()
            );
          };
        }
      } else if (this.columns[i].vue.hasOwnProperty("isDet")) {
        if (this.columns[i].vue.isDet) {
          tmp.createdCell = function (td, cellData, rowData, row, col) {
            $(td).addClass("jh-dtlC");
          };
        }
      }
      out.push(tmp);
    }
    return out;
  }
  /**Obtener un Arreglo de objetos para usar Vue.js unicamente la configuracion de <thead> y <tfoot>.
   * @return {Array} Conjunto de objetos.*/
  getVue_Titles() {
    let out = new Array();
    for (let i = 0; i < this.columns.length; i++) {
      var z = this.columns[i].vue;
      if (this.columns[i].hasOwnProperty("filters")) {
        z.filters = this.columns[i].filters;
      }
      if (
        this.columns[i].hasOwnProperty("type") &&
        this.columns[i].type === "date"
      ) {
        z.isDate = true;
        z.name = this.columns[i].dt.name;
      }
      out.push(z);
    }
    return out;
  }
  /**Obtener el URL de consulta a servidor.
   * @return {String} Valor de url.*/
  getURL() {
    return this.url;
  }
  /**Obtener Array configurativo para DataTable.js, con la columna inicial para ordenar. De no existir devuelve 0 y asc;
   * @return {Array} Conjunto de 1 fila de 2 columnas.*/
  getOrder() {
    let out = [[this.getIniempty(), "asc"]]; //Artilugio, seria la columna default, si no hay empty.
    for (let i = 0; i < this.columns.length; i++) {
      if (this.columns[i].hasOwnProperty("iniOrder")) {
        out = [[i, this.columns[i].iniOrder]];
        break;
      }
    }
    return out;
  }
  /**Obtener columna para usar como select. Si no tiene devuelve -1.
   * @return {Integer} Indice de columna.*/
  getSelectCol() {
    let out = -1; //seria la columna default
    for (let i = 0; i < this.columns.length; i++) {
      if (this.columns[i].vue.hasOwnProperty("isSel")) {
        //ES USADO?
        if (this.columns[i].vue.isSel) {
          //parace innesesario esta verificacion
          out = i;
        }
        break;
      }
    }
    return out;
  }
  /**Consultar si se tienen select
   * @return {Boolean}*/
  chkSelect() {
    let out = false;
    for (let i = 0; i < this.columns.length; i++) {
      if (this.columns[i].vue.hasOwnProperty("isSel")) {
        if (this.columns[i].vue.isSel) {
          //parace innesesario esta verificacion
          out = true;
        }
        break;
      }
    }
    return out;
  }
  /**Consultar si se tienen detail
   * @return {Boolean}*/
  chkDetail() {
    let out = false;
    for (let i = 0; i < this.columns.length; i++) {
      if (this.columns[i].vue.hasOwnProperty("isDet")) {
        if (this.columns[i].vue.isDet) {
          //parace innesesario esta verificacion
          out = true;
        }
        break;
      }
    }
    return out;
  }
  /**Consultar la cantidad de columnas que estaran a la izquierda. Columas como Select y Detail, que no son partes de la consulta a DB.
   * @return {Integer} Cantidad de columnas.*/
  getIniempty() {
    let out = 0; //indicaria default
    for (let i = 0; i < this.columns.length; i++) {
      if (
        this.columns[i].vue.hasOwnProperty("isSel") ||
        this.columns[i].vue.hasOwnProperty("isDet")
      ) {
        //podria optimizarse con funciones de aca mismo
        out++; //optimizable
      }
    }
    return out + "";
  }
  /**Consultar si una columna inicialmente se escogio como visible.
   * @param {Integer} i - Indice del la columna */
  chkVFilter(i) {
    return this.columns[i].dt.visible;
  }
  /**Consultar si se tienen filtros de fechas(rangos).
   * @return {Boolean}*/
  chkDFilters() {
    let out = false;
    for (let i = 0; i < this.columns.length; i++) {
      if (
        this.columns[i].hasOwnProperty("type") &&
        this.columns[i].type === "date"
      ) {
        out = true;
        break;
      }
    }
    return out;
  }
  /**Consultar si se tienen filtros para <tfoot>.
   * @return {Boolean}*/
  chkFFilters() {
    let out = false;
    for (let i = 0; i < this.columns.length; i++) {
      if (this.columns[i].vue.hasOwnProperty("fotserch")) {
        out = true;
        break;
      }
    }
    return out;
  }
  /**Obtener el un mes en particular.
   * @param {Integer} i - Indice para obtener mes. 0 a 11
   * @return {String} Mes en particular*/
  getSMes(i) {
    return this.meses[i];
  }
  /**Obtener el array de meses en español.
   * @returns {Array} Conjunto de meses.(Cadena)*/
  getMess() {
    return this.meses;
  }
  /**Obtener fecha refecencial inicial.
   * @return {String} Valor de fecha. mm-dd-yyy*/
  getFecha_ini() {
    //may change in datatable con datepicker.js
    return this.firdate;
  }
  /**Obtener fecha de actualizacion en la db
   * @return {String} Valor de fecha formateado.*/
  getUpdate() {
    return (
      this.update.getDate() +
      " de " +
      this.getSMes(this.update.getMonth()) +
      " del " +
      this.update.getFullYear() +
      " a las " +
      this.update.getHours() +
      ":" +
      this.update.getMinutes()
    );
  }
  /**Obtener un Arreglo de objetos para usar en Select
   * @return {Array} Conjunto de objetos.*/
  getSelect() {
    let out = new Array();
    let out2 = new Array();
    for (let i = 0; i < this.columns.length; i++) {
      if (this.columns[i].hasOwnProperty("canmv")) {
        //okay
        let sm = this.columns[i].canmv.toString();
        let ali = false;
        if (sm.charAt(0) === "-") {
          ali = true;
          sm = sm.substr(1);
        }
        let oi = {
          txt: this.columns[i].vue.txt,
          key: sm,
          ali: ali,
        };
        let aux = [];
        for (let j = 0; j < this.columns[i].filters.length; j++) {
          aux.push({
            txt: this.columns[i].filters[j].txt,
            key: this.columns[i].filters[j].key,
          });
        }
        oi.vls = aux;
        out.push(oi);
      }
    }
    for (let i = 0; i < this.select.length; i++) {
      if (this.select[i].hasOwnProperty("uts")) {
        out.push({
          txt: this.select[i].txt,
          key: this.select[i].key,
          ali: this.select[i].ali,
          vls: this.select[i].uts,
        });
      } else {
        out2.push(this.select[i]);
      }
    }
    return {
      ups: out,
      juti: out2,
    };
  }

  /*Obtener un Arreglo de enteros con las columnas que tendran total al pie de su columna.*
   *@return {Array} Conjunto de columnas.*/
  getTotals() {
    let out = new Array();
    for (let i = 0; i < this.columns.length; i++) {
      if (this.columns[i].hasOwnProperty("type")) {
        if (this.columns[i].type === "sus") {
          out.push(i);
        }
      }
    }
    return out;
  }
  /**
   * Retornar un autenticador*/
  getAuth() {
    return "123";
  }
  /**Obtener un Arreglo de objetos para usar en Cabezera de titulo, links.
   * @return {Array} Conjunto de objetos.*/
  getSons() {
    return this.sons;
  }
  /**Obtener el key del activo Son.
   * @return {String}*/
  getSon() {
    let out = "null";
    for (let i = 0; i < this.sons.left.length; i++) {
      if (this.sons.left[i].hasOwnProperty("act")) {
        if (this.sons.left[i].act) {
          out = this.sons.left[i].key;
          break;
        }
      }
    }
    return out;
  }
  /**Obtener si tendran busquedas default.
   * @return {Array} Conjunto de objetos.*/
  getDefls() {
    let out = new Array();
    for (let i = 0; i < this.columns.length; i++) {
      if (this.columns[i].hasOwnProperty("filters")) {
        let xp = undefined;
        for (let item of this.columns[i].filters) {
          if (item.hasOwnProperty("act") && item.act) {
            xp = item.key;
            break;
          }
        }
        if (xp !== undefined) {
          out.push({ search: xp });
        } else {
          out.push(null);
        }
      } else {
        out.push(null);
      }
    }
    return out;
  }
}
