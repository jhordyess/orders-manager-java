package Xtra.Places;

import static core.Infos.MsgModel;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import core.DTable.Server_Request;

/**
 *
 * @author jhordyess
 */
public class Model extends core.Models.DBAModel implements core.Models.Model {

  @Override
  public JsonObject ReadAll(Server_Request srobj, String fly) {
    if ((new Ccte()).getReads().equals(fly)) {
      return super.LMDList(1, srobj, "dests");
    } else {
      MsgModel("code error");
      return null;
    }
  }

  @Override
  public String UpdateDate() {
    return super.updateD("lugar_destino");
  }

  @Override
  public String Update(String ky, String val) {
    return super.LDDUpds(ky, val, new Ccte().getArr());
  }

  @Override
  public JsonArray Read(String co) {
    return super.LMDOne("Dest", co);
  }
}
