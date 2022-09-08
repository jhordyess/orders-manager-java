package Order.estado;

import core.Views.CreateReadUpdate;
import static core.Functions.JAtoStr;
import com.google.gson.Gson;
import com.google.gson.JsonArray;

/**
 *
 * @author jhordyess
 */
public class View implements core.Views.View {

  private core.Views.ReadUpdateDelete lst;
  private Model consul;

  @Override
  public String ReadFormat(String kgy) {
    Ccte xd = new Ccte();
    this.lst = new core.Views.ReadUpdateDelete();
    this.consul = new Model();
    if (xd.getReads(0).equals(kgy) || kgy.equals("")) {
      this.Entrante(xd.getReads(0), xd);
    } else if (xd.getReads(1).equals(kgy)) {
      this.Pendiente(xd.getReads(1), xd);
    } else if (xd.getReads(2).equals(kgy)) {
      this.Enviados(xd.getReads(2), xd);
    } else if (xd.getReads(3).equals(kgy)) {
      this.EnviadosD(xd.getReads(3), xd);
    } else if (xd.getReads(4).equals(kgy)) {
      this.Cancer(xd.getReads(4), xd);
    }
    return lst.getAs().toString();
  }

  private void Entrante(String val, Ccte x) {
    this.BasicButton(x);
    this.lst.addSelItem("Aprobar", "fa-plus", x.pendiar(), 1, true);// pendiente
    this.lst.addSelItem("Cancelar", "fa-minus", x.cancelar(), 3, true);
    this.Commons(val, null, false, x);
  }

  private void Pendiente(String val, Ccte x) {
    this.BasicButton(x);
    this.lst.addSelItem("Ver recibo", "fa-receipt", "vr", 0, true);
    this.lst.addSelItem("Hacer itinerario", "fa-arrow-circle-down", "hi", 0, true);
    this.lst.addSelItem("Enviado", "fa-archive", x.enviar(), 1, true);
    this.lst.addSelItem("Enviado sin deuda", "fa-check", x.enviarS(), 1, true);
    this.lst.addSelItem("Cancelar", "fa-minus", x.cancelar(), 3, true);
    this.Commons(val, null, true, x);
  }

  private void Enviados(String val, Ccte x) {
    this.BasicButton(x);
    this.lst.addSelItem("Ver recibo", "fa-receipt", "vr", 0, true);
    this.lst.addSelItem("Cancelar", "fa-minus", x.cancelar(), 3, true);
    this.Commons(val, "Fecha enviada", true, x);
  }

  private void EnviadosD(String val, Ccte x) {
    this.BasicButton(x);
    this.lst.addSelItem("Ver recibo", "fa-receipt", "vr", 0, true);
    this.lst.addSelItem("Cancelar", "fa-minus", x.cancelar(), 3, true);
    this.lst.addSelItem("Quitar deuda", "fa-stamp", x.Salar(), 1, true);
    this.Commons(val, "Fecha enviada", true, x);
  }

  private void Cancer(String val, Ccte x) {
    this.BasicButton(x);
    this.lst.addSelItem("Devolver", "fa-arrow-left", x.devolver(), 1, true);
    this.MySites(val, x);
    this.lst.addTableColFoo(true, "Veces cancelada");
    this.Fechas(null);
    this.Extras(false, x);
    this.setDats();
  }

  private void Commons(String val, String fech, Boolean medios, Ccte x) {
    this.MySites(val, x);
    this.Fechas(fech);
    this.Extras(medios, x);
    this.setDats();
  }

  private void MySites(String vl, Ccte x) {
    String[] ge = x.getReads().split("-");
    this.lst.setSel();
    lst.addButtonItem("Entrante", "fa-calendar-alt", ge[0], vl.equals(ge[0]));
    lst.addButtonItem("Aprobado", "fa-calendar-plus", ge[1], vl.equals(ge[1]));
    lst.addButtonItem("Enviado", "fa-calendar-check", ge[2], vl.equals(ge[2]));
    lst.addButtonItem("Deuda", "fa-calendar-times", ge[3], vl.equals(ge[3]));
    lst.addButtonItem("Cancelado", "fa-calendar-minus", ge[4], vl.equals(ge[4]));
    lst.addButtonItemW("WHA");
    lst.addButtonItemF("FAN");
    lst.addButtonItemE("EML");
    lst.addButtonItemM("MPS");
    lst.setButton();
    this.BasicCols();
  }

  private void BasicCols() {
    lst.addTableColSel();
    lst.addTableColDet();
    lst.addTableColFoo(true, "Numero", false);// no poner en mas de uno!!!!
    lst.addTableColFoo(true, "Nombre");
    lst.addTableColFilT(true, true, "Tipo", consul.getTipos(), "jh1");
    lst.addTableColFillS(true, "Total");
  }

  private void BasicButton(Ccte up) {
    this.lst.addSelItem("Editar", "fa-edit", up.getUpdate(), 0, true);
    this.lst.addSelItem("Eliminar", "fa-trash", up.elimina(), 2, false);
  }

  private void setDats() {
    lst.setTableCols();
    lst.newElem("date", consul.UpdateDate());
    lst.newElem("fdate", core.Functions.tStamp("01-01-2019 00:00:00"));
  }

  private void Fechas(String fech) {
    lst.addTableColFillD(true, true, "Fecha ingreso");
    lst.addTableColFillD(true, true, "Fecha para enviar");
    if (fech != null && fech.length() > 0 && !fech.equals("")) {
      lst.addTableColFillD(true, true, fech);
    }
  }

  private void Extras(Boolean medios, Ccte up) {
    lst.addTableColFil(true, false, "Medio contacto", consul.getMedios(), "-" + up.updateRem1());
    lst.addTableColFil(true, false, "Lugar destino", consul.getDestins(), "-" + up.updateRem2());
    if (medios) {
      this.lst.addTableColFil(true, false, "Medio pago", this.consul.getPagos(), "-" + up.updateRem3());
    }
  }

  @Override
  public String UpdateFormat(String key, String selec) {
    JsonArray aux = (new Gson()).fromJson(selec, JsonArray.class);
    CreateReadUpdate xp = new CreateReadUpdate();
    Ccte nets = new Ccte();
    if (nets.getUpdate().equals(key)) {
      if (aux.size() == 1) {
        xp.setMesage("./ordnew?nav=" + (JAtoStr(aux, 0)));
      } else {
        xp.setMesage("");
      }
    }
    if ("WHA".equals(key) && aux.size() == 1) {
      xp.setSend((new Model()).Whape(JAtoStr(aux, 0)));
    } else if ("FAN".equals(key) && aux.size() == 1) {
      xp.setSend((new Model()).Face(JAtoStr(aux, 0)));
    } else if ("EML".equals(key) && aux.size() == 1) {
      xp.setSend((new Model()).Mail(JAtoStr(aux, 0)));
    } else if ("MPS".equals(key) && aux.size() == 1) {
      xp.setSend((new Model()).Map(JAtoStr(aux, 0)));
    } else if (nets.cancelar().equals(key) && !aux.isEmpty()) {
      xp.setSubElem(xp.new Subme("Razon", "m12", "text", nets.getCanc()[0], "", null, false));
      xp.setElem("Cancelar");
      xp.setMesage("Si desea puede indicar un motivo por la cancelacion.");
    } else if ("vr".equals(key)) {
      if (aux.size() == 1) {
        xp.setMesage("./LaTeX?t=" + (JAtoStr(aux, 0)) + "&s=1#zoom=150");
      } else {
        xp.setMesage("");
      }
    } else if ("hi".equals(key) && !aux.isEmpty()) {
      String tmp = aux.toString();
      tmp = tmp.replace("[", "%5B");
      tmp = tmp.replace("]", "%5D");
      xp.setMesage("./LaTeX?t=" + tmp + "&s=2#view=FitH");
    }
    return xp.toString();
  }
}
