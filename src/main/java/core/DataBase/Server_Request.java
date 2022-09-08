package core.DataBase;

import java.util.ArrayList;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.Gson;

/**
 *
 * @author jhordyess
 */
public class Server_Request {

  public JsonArray selects;
  public String value;
  public ArrayList<inputs> inpus;

  public Server_Request(String value) {
    try {
      JsonObject main = (new Gson()).fromJson(value, JsonObject.class);
      this.inpus = new ArrayList<inputs>();
      this.value = null;
      this.selects = (new Gson()).fromJson(main.get("dt").getAsString(), JsonArray.class);
      if (main.has("ot")) {
        this.value = main.get("ot").getAsString();
      }
      if (main.has("vl")) {
        for (Object object : (new Gson()).fromJson(main.get("vl").getAsString(), JsonArray.class)) {
          JsonObject nop = (new Gson()).fromJson(object.toString(), JsonObject.class);
          this.inpus.add(new inputs(nop.get("val").getAsString(), nop.get("name").getAsString()));
        }
      }
    } catch (Exception e) {
      core.Infos.MsgModel(e.getMessage());
      this.selects = new JsonArray();
      this.value = null;
      this.inpus = new ArrayList<inputs>();
    }
  }

  public Boolean easy() {
    return this.inpus.isEmpty() && this.value == null && !this.selects.isEmpty();
  }

  public Boolean norm() {
    return this.inpus.isEmpty() && this.value != null && !this.selects.isEmpty();
  }

  public Boolean hard() {
    return !this.inpus.isEmpty() && this.value == null && !this.selects.isEmpty();

  }

  public Boolean insane() {
    return !this.inpus.isEmpty() && this.value == null && this.selects.isEmpty();
  }

  public String getInput(String z) {
    String alfa = "";
    for (inputs inpu : this.inpus) {
      if (inpu.getName().equals(z)) {
        alfa = inpu.getVal();
        // this.inpus.remove(inpu);
        break;
      }
    }
    return alfa;
  }

  protected class inputs {

    private String val;
    private String name;

    public inputs(String val, String name) {
      this.val = val;
      this.name = name;
    }

    public String getName() {
      return name;
    }

    public void setName(String name) {
      this.name = name;
    }

    public String getVal() {
      return val;
    }

    public void setVal(String val) {
      this.val = val;
    }

    @Override
    public String toString() {
      return "inputs{" + "val=" + val + ", name=" + name + '}';
    }

  }
}
