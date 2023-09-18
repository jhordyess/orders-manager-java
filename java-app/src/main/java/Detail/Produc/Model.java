package Detail.Produc;

import core.DTable.Server_Request;
import static core.Infos.MsgModel;
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
      return super.LMDList(2, srobj, "prody");
    } else {
      MsgModel("code error");
      return null;
    }
  }

  @Override
  public String UpdateDate() {
    return super.updateD("productos");
  }

  public JsonArray getClase() {
    return super.LMDSkeys("s_clas", null, -1);
  }

  public JsonArray getTags() {
    return super.LMDSkeys("s_tag", null, -1);
  }

  @Override
  public String Update(String ky, String val) {
    return super.LDDUpds(ky, val, new Ccte().getArr());
  }

  @Override
  public JsonArray Read(String co) {
    return super.LMDOne("proc", co);
  }

  public JsonArray obtClases() {
    return super.LMDTwo("r_clas", null, new Ccte().getFr1());
  }

  public JsonArray pereza(String co) {
    return super.LMDTwo("proc_tag", co, "val-ini".split("-"));
  }
}
