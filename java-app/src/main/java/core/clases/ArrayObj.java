package core.clases;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 *
 * @author jhordyess
 */
public class ArrayObj {
  private JsonArray jrray;
  private JsonObject joray;

  public ArrayObj() {
    this.jrray = new JsonArray();
    this.joray = new JsonObject();
  }

  public void insert(String a, Object b) {
    this.joray.add(a, (new Gson()).toJsonTree(b));
  }

  public JsonArray geting() {
    JsonArray aux = this.jrray;
    this.jrray = new JsonArray();
    return aux;
  }

  public void prevAdd() {
    this.jrray.add(this.joray);
    this.joray = new JsonObject();
  }

  public void newAdd(Object b) {
    this.jrray.add((new Gson()).toJsonTree(b));
  }
}
