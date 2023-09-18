package Default;

import com.google.gson.JsonObject;
import core.Views.DefaultMenu;

/**
 *
 * @author jhordyess
 */
public class View {

  public JsonObject getMenu(String main) {
    String np = "?nav=";
    DefaultMenu ira = new DefaultMenu();
    ira.addIniItem(main + "/main-board.html", "fa-home", "Home");
    ira.addSepItem(main + "/cliente" + np, "fa-user-tie", "Clientes");
    ira.addItem(main + "/dist" + np, "fa-id-card", "Distribuidores");
    ira.addItem(main + "/eve" + np, "fa-building", "Eventos");
    //
    ira.addSepItem(main + "/ordsen" + np, "fa-shopping-cart", "Pedidos");
    ira.addItemModal(main + "/ordnew" + np, "fa-shopping-bag", "Nuevo Pedido");
    //
    ira.addSepItem(main + "/pro" + np, "fa-coffee", "Productos");
    ira.addItem(main + "/siz" + np, "fa-paperclip", "Tallas");
    //
    ira.addSepItem(main + "/mcont" + np, "fa-comments", "Medio de contacto");
    ira.addItem(main + "/ldestino" + np, "fa-map", "Lugar Destino");
    ira.addItem(main + "/pays" + np, "fa-credit-card", "Medios de pago");
    return ira.getAs();
  }
}
