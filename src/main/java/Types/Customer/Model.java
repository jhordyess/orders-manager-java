package Types.Customer;

import core.DTable.Server_Request;
import static core.Infos.MsgModel;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 *
 * @author jhordyess
 */
public class Model extends core.Models.DBAModel implements core.Models.Model {

  @Override
  public JsonObject ReadAll(Server_Request srobj, String fly) {
    if ((new Ccte()).getReads().equals(fly)) {
      return super.LMDList(2, srobj, "clies");
    } else {
      MsgModel("code error");
      return null;
    }
  }

  @Override
  public String UpdateDate() {
    return super.updateD("cliente");
  }

  @Override
  public String Update(String ky, String val) {
    return super.LDDUpds(ky, val, new Ccte().getArr());
  }

  @Override
  public JsonArray Read(String co) {
    return super.LMDOne("cli", co);
  }

  public JsonArray obtDistribs() {
    return super.LMDTwo("r_dist", null, new Ccte().getFr1());
  }

  public JsonArray obtEves() {
    return super.LMDTwo("r_even", null, new Ccte().getFr1());
  }

  public String Whape(String who) {
    return super.LMDSimple(
        "SELECT IF(celular is null or celular='' or celular='-','',celular) as jh3 FROM `cliente` WHERE nombre='" + who
            + "';");
  }

  public String Face(String who) {
    return super.LMDSimple(
        "SELECT IF(face is null or face='' or face='-','',face) as jh3 FROM `cliente` WHERE nombre='" + who + "';");
  }

  public String Mail(String who) {
    return super.LMDSimple(
        "SELECT IF(email is null or email='' or email='-','',email) as jh3 FROM `cliente` WHERE nombre='" + who + "';");
  }

  public String Sincro(String ky, String val) {
    JsonObject OBJ = new JsonObject();
    JsonArray orale = new JsonArray();
    if (ky.equals("SyC")) {
      try {
        //
      } catch (Exception e) {
        MsgModel("No puede sincronizarse" + e.getMessage());
        OBJ.add("sw", (new Gson()).toJsonTree(false));
      }
    } else {
      OBJ.add("sw", (new Gson()).toJsonTree(false));
    }
    OBJ.add("rnk", orale);
    return OBJ.toString();
  }
}
