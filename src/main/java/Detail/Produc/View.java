package Detail.Produc;

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
      lst.addSelItem("Quitar clase", "fa-undo", nets.reclas(), 2, false);
      lst.addSelItem("Añadir tag", "fa-tag", nets.darTag(), 3, true);
      lst.setSel();
      lst.addButtonItem("Productos", "fa-calendar-alt", nets.getReads(), true);
      lst.addButtonItem("Nuevo", "fa-plus", nets.getCreate(), false);
      // lst.addButtonItem("Remover tag", "fa-plus", "CN", false);
      lst.setButton();
      lst.addTableColSel();
      lst.addTableColDet();
      lst.addTableColFoo(true, "Código");
      lst.addTableColFil(true, true, "Clase", consul.getClase(), nets.clase());
      lst.addTableColFil(true, true, "Tags", consul.getTags());
      lst.addTableColFoo(true, "Demanda en pedidos");
      lst.addTableColFillB(false, true, "Habilitado", nets.updateRem());
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
        xp.setSubElem(xp.new Subme("Codigo", "m4", "text", nets.getFrms()[0], JAtoStr(tmp, 0), null, true));
        xp.setSubElem(
            xp.new Subme("Habilitado", "m2", "bool", nets.getFrms()[1], JAtoStr(tmp, 1), null, null));
        xp.setSubElem(
            xp.new Subme("Descripcion", "m6", "text", nets.getFrms()[2], JAtoStr(tmp, 2), null, null));
        xp.setElem("Producto");
        xp.setSubElem(
            xp.new Subme("Nombre", "m6", "text", nets.getFr1()[0], JAtoStr(tmp, 3), true, true, false));
        xp.setSubElem(xp.new Subme("Habilitado", "m6", "bool", nets.getFr1()[1], JAtoStr(tmp, 4), null, null));
        xp.setElem("Clase", (new Model()).obtClases());
        //
        xp.setSubElem(xp.new Subme("Nombres", "m12", nets.getFr2()[0], (new Model()).pereza(JAtoStr(aux, 0))));
        xp.setElem("Tags");
        xp.setMesage("El codigo identifica al producto.");
      } else {
        xp.setMesage("No puede editar mas de uno a la vez!");
      }
    } else if (nets.getCreate().equals(key) && aux.isEmpty()) {
      xp.setSubElem(xp.new Subme("Codigo", "m4", "text", nets.getFrms()[0], "", null, true));
      xp.setSubElem(xp.new Subme("Habilitado", "m2", "bool", nets.getFrms()[1], "0", null, null));
      xp.setSubElem(xp.new Subme("Descripcion", "m6", "text", nets.getFrms()[2], "", null, null));
      xp.setElem("Producto");
      xp.setSubElem(xp.new Subme("Nombre", "m6", "text", nets.getFr1()[0], "", true, true, false));
      xp.setSubElem(xp.new Subme("Habilitado", "m6", "bool", nets.getFr1()[1], "0", null, null));
      xp.setElem("Clase", (new Model()).obtClases());
      //
      xp.setSubElem(xp.new Subme("Nombres", "m12", nets.getFr2()[0], (new Model()).pereza(" ")));
      xp.setElem("Tags");
      xp.setMesage("El codigo identifica al producto.");
    } else if (nets.darTag().equals(key) && !aux.isEmpty()) {
      xp.setSubElem(xp.new Subme("Nombres", "m12", nets.getFr2()[0], (new Model()).pereza(" ")));
      xp.setElem("Tags");
      xp.setMesage("Si lo seleccionado ya tuvo, seran reemplazados por lo nuevo. Lo vacio quita el tag.");
    }
    return xp.toString();
  }
}
