package core.clases;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 *
 * @author jhordyess
 */
public class ObjectObj {

  private JsonObject dad;
  private JsonObject son;

  public ObjectObj() {
    this.dad = new JsonObject();
    this.son = new JsonObject();
  }

  public void insert(String a, Object b) {
    this.son.add(a, (new Gson()).toJsonTree(b));
  }

  public JsonObject geting() {
    JsonObject aux = this.dad;
    this.dad = new JsonObject();
    return aux;
  }

  public void prevAdd(String key) {
    this.dad.add(key, this.son);
    this.son = new JsonObject();
  }

  public void newAdd(String a, Object b) {
    this.dad.add(a, (new Gson()).toJsonTree(b));
  }
}
