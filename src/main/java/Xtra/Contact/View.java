package Xtra.Contact;

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
      core.Views.ReadUpdateDelete lst = new core.Views.ReadUpdateDelete();
      lst.addSelItem("Editar", "fa-edit", nets.getUpdate(), 3, true);
      lst.addSelItem("Eliminar", "fa-trash", nets.elimina(), 2, false);
      lst.setSel();
      // Botones de cabezera
      lst.addButtonItem("Medios de contacto", "fa-calendar-alt", nets.getReads(), true);
      lst.addButtonItem("Nuevo", "fa-plus", nets.getCreate(), false);
      lst.setButton();
      // Columnas
      lst.addTableColSel();
      lst.addTableColFoo(true, "Nombre");
      lst.addTableColFillB(true, true, "Recordar", nets.updateRem());
      lst.setTableCols();
      //
      lst.newElem("date", (new Model()).UpdateDate());
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
        xp.setSubElem(xp.new Subme("Nombre", "m6", "text", nets.getFrms()[0], JAtoStr(tmp, 0), null, true));
        xp.setSubElem(xp.new Subme("Recordar", "m6", "bool", nets.getFrms()[1], JAtoStr(tmp, 1), null, null));
        xp.setElem("Medio de contacto");
        xp.setMesage("No puede repetir nombres.");
      } else {
        xp.setMesage("No puede editar mas de uno a la vez!");
      }
    } else if (nets.getCreate().equals(key) && aux.isEmpty()) {
      xp.setSubElem(xp.new Subme("Nombre", "m6", "text", nets.getFrms()[0], "", null, true));
      xp.setSubElem(xp.new Subme("Recordar", "m6", "bool", nets.getFrms()[1], "0", null, null));
      xp.setElem("Medio de contacto");
      xp.setMesage("No puede repetir nombres.");
    }
    return xp.toString();
  }
}
