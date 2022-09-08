package Order.estado;

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
  public JsonObject ReadAll(Server_Request srobj, String kgy) {
    String tbl = "";
    Ccte xd = new Ccte();
    if (xd.getReads(0).equals(kgy)) {
      tbl = "ped_entra";
    } else if (xd.getReads(1).equals(kgy)) {
      tbl = "ped_pendien";
    } else if (xd.getReads(2).equals(kgy)) {
      tbl = "ped_enviado";
    } else if (xd.getReads(3).equals(kgy)) {
      tbl = "ped_enviadod";
    } else if (xd.getReads(4).equals(kgy)) {
      tbl = "ped_cancer";
    }
    if (!tbl.equals("")) {
      xd = null;
      return super.LMDList(2, srobj, tbl);
    } else {
      MsgModel("code error");
      return null;
    }
  }

  @Override
  public String UpdateDate() {
    return super.updateD("pedido");
  }

  public JsonArray getTipos() {
    JsonArray ray = new JsonArray();
    JsonObject two = new JsonObject();
    two.add("txt", (new Gson()).toJsonTree("Distribuidor"));
    two.add("key", (new Gson()).toJsonTree("1"));
    ray.add(two);
    two = new JsonObject();
    two.add("txt", (new Gson()).toJsonTree("Normal"));
    two.add("key", (new Gson()).toJsonTree("2"));
    ray.add(two);
    two = new JsonObject();
    two.add("txt", (new Gson()).toJsonTree("Normal de evento"));
    two.add("key", (new Gson()).toJsonTree("3"));
    ray.add(two);
    two = new JsonObject();
    two.add("txt", (new Gson()).toJsonTree("Normal de distribuidor"));
    two.add("key", (new Gson()).toJsonTree("4"));
    ray.add(two);
    return ray;
  }

  public JsonArray getMedios() {
    return super.LMDSkeys("s_pContac", null, -1);
  }

  public JsonArray getDestins() {
    return super.LMDSkeys("s_pDestin", null, -1);
  }

  public JsonArray getPagos() {
    return super.LMDSkeys("s_pPay", null, -1);
  }

  @Override
  public String Update(String ky, String val) {
    return super.LDDUpds(ky, val, new Ccte().getArr());
  }

  @Override
  public JsonArray Read(String co) {
    // return super.LMDOne("Pay", co);
    throw new UnsupportedOperationException("Not supported yet.");
  }

  public String Whape(String who) {
    return super.LMDSimple("call vermi('" + who + "',1);");
  }

  public String Face(String who) {
    return super.LMDSimple("call vermi('" + who + "',2);");
  }

  public String Mail(String who) {
    return super.LMDSimple("call vermi('" + who + "',3);");
  }

  public String Map(String who) {
    return super.LMDSimple("call get_geo('" + who + "');");
  }
}
