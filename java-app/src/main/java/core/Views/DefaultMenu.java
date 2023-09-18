package core.Views;

import com.google.gson.JsonObject;

/**
 *
 * @author jhordyess
 */
public class DefaultMenu {

  private final core.clases.ObjectObj mtr;
  private final core.clases.ArrayObj arr;

  public DefaultMenu() {
    this.mtr = new core.clases.ObjectObj();
    this.arr = new core.clases.ArrayObj();
  }

  public void addIniItem(String url, String ico, String texto) {
    this.arr.insert("link", url);
    this.arr.insert("ico", ico);
    this.arr.insert("txt", texto);
    this.arr.insert("isAct", true);
    this.arr.prevAdd();
  }

  public void addItem(String url, String ico, String texto) {
    this.arr.insert("link", url);
    this.arr.insert("ico", ico);
    this.arr.insert("txt", texto);
    this.arr.insert("isAct", false);
    this.arr.prevAdd();
  }

  public void addSepItem(String url, String ico, String texto) {
    this.arr.insert("link", url);
    this.arr.insert("ico", ico);
    this.arr.insert("txt", texto);
    this.arr.insert("isSep", true);
    this.arr.insert("isAct", false);
    this.arr.prevAdd();
  }

  public void addItemModal(String url, String ico, String texto) {
    this.arr.insert("link", url);
    this.arr.insert("ico", ico);
    this.arr.insert("txt", texto);
    this.arr.insert("isAct", false);
    this.arr.insert("isMod", true);
    this.arr.prevAdd();
  }

  public JsonObject getAs() {
    this.mtr.newAdd("menu", this.arr.geting());
    return this.mtr.geting();
  }
}
