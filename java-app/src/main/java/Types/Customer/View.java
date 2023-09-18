package Types.Customer;

import static core.Infos.MsgView;
import static core.Functions.JAtoStr;
import core.Views.CreateReadUpdate;
import com.google.gson.Gson;
import com.google.gson.JsonArray;

/**
 *
 * @author jhordyess
 */
public class View implements core.Views.View {

  @Override
  public String ReadFormat(String fly) {
    Ccte nets = new Ccte();
    if (nets.getReads().equals(fly) || fly.equals("")) {
      Model consul = new Model();
      core.Views.ReadUpdateDelete lst = new core.Views.ReadUpdateDelete();
      lst.addSelItem("Editar", "fa-edit", nets.getUpdate(), 3, true);
      lst.addSelItem("Eliminar", "fa-trash", nets.elimina(), 2, false);
      lst.addSelItem("Hacer Distribuidor", "fa-id-card", nets.distrib(), 3, true);
      lst.addSelItem("Hacer Eventista", "fa-building", nets.evento(), 3, true);
      lst.setSel();
      // Botones de cabezera
      lst.addButtonItem("Clientes", "fa-calendar-alt", nets.getReads(), true);
      lst.addButtonItem("Sync con Web", "fa-cloud", "SyC", false);
      lst.addButtonItem("Nuevo Cliente", "fa-plus", nets.getCreate(), false);
      lst.addButtonItemW("WHA");
      lst.addButtonItemF("FAN");
      lst.addButtonItemE("EML");
      lst.setButton();
      // Columnas
      lst.addTableColSel();
      lst.addTableColDet();
      lst.addTableColFoo(true, "Nombre");
      lst.addTableColFoo(true, "Carnet Identidad");
      lst.addTableColFoo(true, "Celular");
      lst.addTableColFoo(true, "Email");
      lst.addTableColFoo(true, "F. User");
      lst.addTableColFillB(true, true, "Recordar", nets.updateRem());
      lst.setTableCols();
      lst.newElem("date", consul.UpdateDate());
      return lst.getAs().toString();
    } else {
      MsgView("code error");
      return null;
    }
  }

  @Override
  public String UpdateFormat(String key, String selec) {
    JsonArray aux = (new Gson()).fromJson(selec, JsonArray.class);
    CreateReadUpdate xp = new CreateReadUpdate();
    Ccte nets = new Ccte();
    if (nets.getUpdate().equals(key)) {
      if (aux.size() == 1) {
        JsonArray tmp = (new Model()).Read(JAtoStr(aux, 0));
        xp.setSubElem(xp.new Subme("Nombre", "m4", "text", nets.getFrms()[0], JAtoStr(tmp, 0), null, true));
        xp.setSubElem(
            xp.new Subme("Carnet Identidad", "m4", "text", nets.getFrms()[1], JAtoStr(tmp, 1), null, false));
        xp.setSubElem(xp.new Subme("Celular", "m4", "text", nets.getFrms()[2], JAtoStr(tmp, 2), null, false));
        xp.setSubElem(xp.new Subme("Email", "m4", "text", nets.getFrms()[3], JAtoStr(tmp, 3), null, false));
        xp.setSubElem(
            xp.new Subme("Facebook user", "m4", "text", nets.getFrms()[4], JAtoStr(tmp, 4), null, false));
        xp.setSubElem(xp.new Subme("Recordar", "m4", "bool", nets.getFrms()[5], JAtoStr(tmp, 5), null, null));
        xp.setElem("Cliente");
        xp.setMesage("El cliente puede representar un evento o distribuidor.");
      } else {
        xp.setMesage("No puede editar mas de uno a la vez!");
      }
    } else if (nets.evento().equals(key)) {
      xp.setSubElem(xp.new Subme("Nombre", "m6", "text", nets.getFr1()[0], "", true, true, true));
      xp.setSubElem(xp.new Subme("Recordar", "m6", "bool", nets.getFr1()[1], "0", null, null));
      xp.setElem("Evento", (new Model()).obtEves());
      xp.setMesage(
          "El evento(nuevo u obtenido) sera reemplazado por el cliente que selecciono; incluso, el cliente sera recordado.");
    } else if (nets.distrib().equals(key)) {
      xp.setSubElem(xp.new Subme("Nombre", "m6", "text", nets.getFr1()[0], "", true, true, true));
      xp.setSubElem(xp.new Subme("Recordar", "m6", "bool", nets.getFr1()[1], "0", null, null));
      xp.setElem("Distribuidor", (new Model()).obtDistribs());
      xp.setMesage(
          "El distribuidor(nuevo u obtenido) sera reemplazado por el cliente que selecciono; incluso, el cliente sera recordado.");
    } else if (nets.getCreate().equals(key) && aux.isEmpty()) {
      xp.setSubElem(xp.new Subme("Nombre", "m4", "text", nets.getFrms()[0], "", null, true));
      xp.setSubElem(xp.new Subme("Carnet Identidad", "m4", "text", nets.getFrms()[1], "", null, false));
      xp.setSubElem(xp.new Subme("Celular", "m4", "text", nets.getFrms()[2], "", null, false));
      xp.setSubElem(xp.new Subme("Email", "m4", "text", nets.getFrms()[3], "", null, false));
      xp.setSubElem(xp.new Subme("Facebook user", "m4", "text", nets.getFrms()[4], "", null, false));
      xp.setSubElem(xp.new Subme("Recordar", "m4", "bool", nets.getFrms()[5], "0", null, null));
      xp.setElem("Cliente");
      xp.setMesage("El cliente nuevo");
    } else if ("WHA".equals(key) && aux.size() == 1) {
      xp.setSend((new Model()).Whape(JAtoStr(aux, 0)));
    } else if ("FAN".equals(key) && aux.size() == 1) {
      xp.setSend((new Model()).Face(JAtoStr(aux, 0)));
    } else if ("EML".equals(key) && aux.size() == 1) {
      xp.setSend((new Model()).Mail(JAtoStr(aux, 0)));
    }
    return xp.toString();
  }

}
