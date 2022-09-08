package core.Views;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 *
 * @author jhordyess
 */
public class CreateReadUpdate {

  private JsonObject ul;
  private JsonObject sul;
  private JsonArray xp;
  private JsonArray sxp;

  public CreateReadUpdate() {
    this.ul = new JsonObject();
    this.sul = new JsonObject();
    this.xp = new JsonArray();
    this.sxp = new JsonArray();
  }

  public void setSend(String val) {
    this.ul.add("npm", (new Gson()).toJsonTree(val));
  }

  public void setMesage(String val) {
    this.ul.add("arr", this.xp);
    this.ul.add("msg", (new Gson()).toJsonTree(val));
    this.xp = new JsonArray();
  }

  public void setSubElem(Subme np) {
    this.sxp.add(np.my);
  }

  public void setElem(String name) {
    this.sul.add("name", (new Gson()).toJsonTree(name));
    this.sul.add("subs", this.sxp);
    this.sul.add("lst", (new JsonArray()));
    this.sxp = new JsonArray();
    this.xp.add(this.sul);
    this.sul = new JsonObject();
  }

  public void setElem(String name, JsonArray lst) {
    this.sul.add("name", (new Gson()).toJsonTree(name));
    this.sul.add("subs", this.sxp);
    try {
      this.sul.add("lst", (lst == null) ? (new JsonArray()) : lst);
    } catch (Exception e) {
    }
    this.sxp = new JsonArray();
    this.xp.add(this.sul);
    this.sul = new JsonObject();
  }

  public void setElem(String name, JsonArray lst, String def) {
    this.sul.add("name", (new Gson()).toJsonTree(name));
    this.sul.add("type", (new Gson()).toJsonTree("n2m"));
    this.sul.add("subs", new JsonArray());
    this.sul.add("def", (new Gson()).toJsonTree(def));
    try {
      this.sul.add("lst", (lst == null) ? (new JsonArray()) : lst);
    } catch (Exception e) {
    }
    this.xp.add(this.sul);
    this.sul = new JsonObject();
  }

  @Override
  public String toString() {
    String aux = this.ul.toString();
    this.ul = new JsonObject();
    return aux;
  }

  /**
   * Obtimizable entre dos en 1.
   */
  public class Subme {

    public JsonObject my;

    /**
     * Creacion de N a M objetos.
     *
     * @param txt  Nombre.
     * @param css  Stylo.
     * @param name Nick
     * @param xd   con objectos ini=="1" para incluir y val
     */
    public Subme(String txt, String css, String name, JsonArray xd) {
      this.my = new JsonObject();
      this.my.add("txt", (new Gson()).toJsonTree(txt));
      this.my.add("css", (new Gson()).toJsonTree(css));
      this.my.add("type", (new Gson()).toJsonTree("12n"));
      this.my.add("name", (new Gson()).toJsonTree(name));
      this.my.add("lst", ((xd == null) ? new JsonArray() : xd));
    }

    /**
     * @param txt  Nombre que tendra.
     * @param css  Clase para la grid.
     * @param type Tipo, si corresponde.
     * @param name nickname para identificarse.
     * @param val  Valor inicial que tendra ideal que se tenga en todo los tipos.
     * @param lst  Si es un input, con una lista para autorellenarse. Ojo que no
     *             afectara a otros.
     * @param req  Si sera requerido como validacion.
     */
    public Subme(String txt, String css, String type, String name, String val, Boolean lst, Boolean req) {
      this.my = new JsonObject();
      this.my.add("txt", (new Gson()).toJsonTree(txt));
      this.my.add("css", (new Gson()).toJsonTree(css));
      this.my.add("type", (new Gson()).toJsonTree(type));
      this.my.add("name", (new Gson()).toJsonTree(name));
      this.my.add("val", (new Gson()).toJsonTree(val));
      this.my.add("req", (new Gson()).toJsonTree(((req == null) ? "0" : (req ? "1" : "0"))));
      this.my.add("hls", (new Gson()).toJsonTree(((lst == null) ? false : lst)));
      this.my.add("chg", (new Gson()).toJsonTree(false));
    }

    /**
     * @param txt  Nombre que tendra.
     * @param css  Clase para la grid.
     * @param type Tipo, si corresponde.
     * @param name nickname para identificarse.
     * @param val  Valor inicial que tendra ideal que se tenga en todo los tipos.
     * @param lst  Si es un input, con una lista para autorellenarse.
     * @param chg  Si 'lst' es verdadero, el cambio al escoger de la lista
     *             afectara a otros segun nickname.
     * @param req  Si sera requerido como validacion.
     */
    public Subme(String txt, String css, String type, String name, String val, Boolean lst, Boolean chg, Boolean req) {
      this.my = new JsonObject();
      this.my.add("txt", (new Gson()).toJsonTree(txt));
      this.my.add("css", (new Gson()).toJsonTree(css));
      this.my.add("type", (new Gson()).toJsonTree(type));
      this.my.add("name", (new Gson()).toJsonTree(name));
      this.my.add("val", (new Gson()).toJsonTree(val));
      this.my.add("req", (new Gson()).toJsonTree((req == null) ? "0" : (req ? "1" : "0")));
      this.my.add("hls", (new Gson()).toJsonTree(lst));// ? si tendra lista
      this.my.add("chg", (new Gson()).toJsonTree(chg));// ? si afectara a quien corresponda con su cambio
    }

    @Override
    public String toString() {
      String aux = this.my.toString();
      this.my = new JsonObject();
      return aux;
    }
  }
}
