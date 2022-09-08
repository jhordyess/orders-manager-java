package core.Views;

import java.util.Random;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 *
 * @author jhordyess
 */
public class ReadUpdateDelete {

  private final core.clases.ObjectObj mtr;
  private final core.clases.ArrayObj arr;
  private final core.clases.ObjectObj submtr;
  private final core.clases.ArrayObj subarr;

  public ReadUpdateDelete() {
    this.mtr = new core.clases.ObjectObj();
    this.arr = new core.clases.ArrayObj();
    this.submtr = new core.clases.ObjectObj();
    this.subarr = new core.clases.ArrayObj();
  }

  /**
   * Definir un nuevo boton al Select.
   *
   * @param txt   Texto a mostrar.
   * @param ico   Icono a usar.
   * @param key   Llave para usar.
   * @param modal Codigo para modal.
   * @param ali   Alineacion
   */
  public void addSelItem(String txt, String ico, String key, int modal, Boolean ali) {
    this.arr.insert("txt", txt);
    this.arr.insert("ico", ico);
    this.arr.insert("key", key);
    this.arr.insert("mod", modal);
    this.arr.insert("ali", ali);
    this.arr.prevAdd();
  }

  public void addSelItem(String txt, String key, JsonArray vls, Boolean ali) {
    this.arr.insert("txt", txt);
    this.arr.insert("key", key);
    this.arr.insert("ali", !ali);
    //
    try {
      this.arr.insert("uts", (null == vls) ? (new JsonArray()) : vls);
      this.arr.prevAdd();
    } catch (Exception e) {

    }
  }

  /**
   * Finalizar la configuracion de botones al Select.
   */
  public void setSel() {
    this.mtr.newAdd("select", this.arr.geting());
  }

  /**
   * Definir un nuevo boton en cabezera de la card.
   *
   * @param txt Texto a mostrar.
   * @param ico Icono a usar.
   * @param key Llave para usar.
   * @param act Si sera activo.
   */
  public void addButtonItem(String txt, String ico, String key, Boolean act) {
    this.arr.insert("txt", txt);
    this.arr.insert("ico", ico);
    this.arr.insert("key", key);
    this.arr.insert("act", act);
    this.arr.prevAdd();
  }

  public void addButtonItemW(String txt) {
    this.addButtonItem("whap", txt);
  }

  private void addButtonItem(String tipo, String txt) {
    this.subarr.insert("typ", tipo);
    this.subarr.insert("key", txt);
    this.subarr.prevAdd();
  }

  public void addButtonItemF(String txt) {
    this.addButtonItem("face", txt);
  }

  public void addButtonItemM(String txt) {
    this.addButtonItem("maps", txt);
  }

  public void addButtonItemE(String txt) {
    this.addButtonItem("emil", txt);
  }

  /**
   * Finalizar la configuracion de botones en cabezera de la card.
   */
  public void setButton() {
    JsonObject jts = new JsonObject();
    jts.add("left", this.arr.geting());
    jts.add("right", this.subarr.geting());
    this.mtr.newAdd("sons", jts);
  }

  /**
   * Incluir una columna con la opcion de seleccion.
   */
  public void addTableColSel() {
    this.basic(false, false, true, "sele");
    this.submtr.insert("className", "select-checkbox");
    this.submtr.insert("width", "1%");
    this.submtr.prevAdd("dt");
    this.submtr.insert("isSel", true);
    this.submtr.prevAdd("vue");
    this.arr.newAdd(this.submtr.geting());

  }

  /**
   * Incluir una columna con la opcion de detalle.
   */
  public void addTableColDet() {
    this.basic(false, false, true, "dete");
    this.submtr.insert("className", "jh-dtl");
    this.submtr.prevAdd("dt");
    this.submtr.insert("isDet", true);
    this.submtr.prevAdd("vue");
    this.arr.newAdd(this.submtr.geting());
  }

  /**
   * Incluir una columna sencilla con pie de busqueda.
   *
   * @param ordeable Si sera ordenable.
   * @param txt      El texto en titulo.
   */
  public void addTableColFoo(Boolean ordeable, String txt) {
    this.complex(ordeable, true, true, txt, true);
    this.arr.newAdd(this.submtr.geting());
  }

  public void addTableColFoo(Boolean ordeable, String txt, Boolean ordenar) {
    this.complex(ordeable, true, true, txt, true);
    this.submtr.newAdd("iniOrder", (ordenar ? "asc" : "desc"));
    this.arr.newAdd(this.submtr.geting());
  }

  /**
   * Incluir una columna con filtros encima de la tabla. Ojo no tendra busqueda
   * de pie de columna.
   *
   * @param ordeable Si sera ordenable.
   * @param visible  Si sera visible.
   * @param txt      El texto en titulo.
   * @param filters  Array bidimencional con los valores en filtro. EL primero es
   *                 Text.
   * @param kyg      Si tendra movimientos.
   */
  public void addTableColFil(Boolean ordeable, Boolean visible, String txt, JsonArray filters, String kyg) {
    this.filtra(ordeable, visible, txt, filters, null, kyg);
  }

  public void addTableColFil(Boolean ordeable, Boolean visible, String txt, JsonArray filters) {
    this.filtra(ordeable, visible, txt, filters, null, null);
  }

  /**
   * Incluir una columna con filtros encima de la tabla. Ojo no tendra busqueda
   * de pie de columna.
   *
   * @param ordeable Si sera ordenable.
   * @param visible  Si sera visible.
   * @param txt      El texto en titulo.
   * @param filters  Array bidimencional con los valores en filtro. EL primero es
   *                 Text.
   * @param typ      Nombre de tipo
   * @param kyg      Si tendra movimientos.
   */
  public void addTableColFilT(Boolean ordeable, Boolean visible, String txt, JsonArray filters, String typ,
      String kyg) {
    this.filtra(ordeable, visible, txt, filters, typ, kyg);
  }

  public void addTableColFilT(Boolean ordeable, Boolean visible, String txt, JsonArray filters, String typ) {
    this.filtra(ordeable, visible, txt, filters, typ, null);
  }

  /**
   * Incluir una columna con filtros Booleanos encima de la tabla.
   *
   * @param ordeable Si sera ordenable.
   * @param visible  Si sera visible.
   * @param txt      El texto en titulo.
   * @param kyg      Si tendra movimientos.
   * @param def      Indice de filtro para marcar como inicial.
   */
  public void addTableColFillB(Boolean ordeable, Boolean visible, String txt, String kyg, int def) {
    this.addTableColFilT(ordeable, visible, txt, core.Functions.booles(def), "sw", kyg);
  }

  public void addTableColFillB(Boolean ordeable, Boolean visible, String txt, String kyg) {
    this.addTableColFilT(ordeable, visible, txt, core.Functions.booles(-1), "sw", kyg);
  }

  public void addTableColFillB(Boolean ordeable, Boolean visible, String txt, int def) {
    this.addTableColFilT(ordeable, visible, txt, core.Functions.booles(def), "sw");
  }

  public void addTableColFillB(Boolean ordeable, Boolean visible, String txt) {
    this.addTableColFilT(ordeable, visible, txt, core.Functions.booles(-1), "sw");
  }

  /**
   * Incluir una columna con filtros de Genero encima de la tabla.
   *
   * @param ordeable Si sera ordenable.
   * @param visible  Si sera visible.
   * @param kyg      Si tendra movimientos.
   * @param def      Indice de filtro para marcar como inicial.
   */
  public void addTableColFillG(Boolean ordeable, Boolean visible, String kyg, int def) {
    this.addTableColFilT(ordeable, visible, "Genero", core.Functions.generos(def), "gen", kyg);
  }

  public void addTableColFillG(Boolean ordeable, Boolean visible, String kyg) {
    this.addTableColFilT(ordeable, visible, "Genero", core.Functions.generos(-1), "gen", kyg);
  }

  public void addTableColFillG(Boolean ordeable, Boolean visible, int def) {
    this.addTableColFilT(ordeable, visible, "Genero", core.Functions.generos(def), "gen");
  }

  public void addTableColFillG(Boolean ordeable, Boolean visible) {
    this.addTableColFilT(ordeable, visible, "Genero", core.Functions.generos(-1), "gen");
  }

  /**
   * Incluir una columna Total encima de la tabla.
   *
   * @param ordeable Si sera ordenable.
   * @param txt      El texto en titulo.
   * @param kyg      Si tendra movimientos.
   */
  public void addTableColFillS(Boolean ordeable, String txt, String kyg) {
    this.addTableColFilT(ordeable, true, txt, null, "sus", null);
  }

  public void addTableColFillS(Boolean ordeable, String txt) {
    this.addTableColFilT(ordeable, true, txt, null, "sus");
  }

  /**
   * Incluir una columna con filtros de Fecha encima de la tabla.
   *
   * @param ordeable Si sera ordenable.
   * @param visible  Si sera visible.
   * @param txt      El nombre de la columna.
   */
  public void addTableColFillD(Boolean ordeable, Boolean visible, String txt) {
    this.filtra(ordeable, visible, txt, null, "date", null);
  }

  private void filtra(Boolean ordeable, Boolean visible, String txt, JsonArray filters, String type, String kyg) {

    this.complex(ordeable, true, visible, txt, false);

    if (filters != null) {
      this.help(filters);
    }
    if (type != null) {
      this.submtr.newAdd("type", type);
    }
    if (kyg != null) {
      this.submtr.newAdd("canmv", kyg);
    }
    this.arr.newAdd(this.submtr.geting());
  }

  private void help(JsonArray filters) {
    this.submtr.newAdd("filters", filters);
  }

  /**
   * Finalizar la configuracion de filtros encima la tabla.
   */
  public void setTableCols() {
    this.mtr.newAdd("columns", this.arr.geting());
  }

  /**
   * Añadir un nuevo elemento.
   *
   * @param name Valor en string a añadir.
   * @param elem Objeto por enviar.
   */
  public void newElem(String name, Object elem) {
    this.mtr.newAdd(name, elem);
  }

  public JsonObject getAs() {
    return this.mtr.geting();
  }

  private void basic(Boolean a, Boolean b, Boolean c, String d) {
    this.submtr.insert("orderable", a);
    this.submtr.insert("searchable", b);
    this.submtr.insert("visible", c);
    this.submtr.insert("name", d);
  }

  private void complex(Boolean a, Boolean b, Boolean c, String e, Boolean f) {
    this.basic(a, b, c, cmp(e));
    this.submtr.prevAdd("dt");
    this.submtr.insert("txt", e);
    if (f) {
      this.submtr.insert("fotserch", true);
    }
    this.submtr.prevAdd("vue");
  }

  private int ux = 0;

  private String cmp(String x) {
    Random r = new Random();
    x = x.replaceAll(" ", "").toLowerCase();
    if (x.length() > 3) {
      x = x.substring(0, 2);
    }
    return x.charAt(r.nextInt(x.length())) + x + (++ux);
  }
}
