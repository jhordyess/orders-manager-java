package Types.Event;

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
      return super.LMDList(2, srobj, "even");
    } else {
      MsgModel("code error");
      return null;
    }
  }

  @Override
  public String UpdateDate() {
    return super.updateD("evento");
  }

  @Override
  public String Update(String ky, String val) {
    return super.LDDUpds(ky, val, new Ccte().getArr());
  }

  @Override
  public JsonArray Read(String co) {
    return super.LMDOne("eve", co);
  }

  public JsonArray getCLientes() {
    return super.LMDSkeys("s_clien", null, -1);
  }

  public String Whape(String who) {
    return super.LMDSimple(
        "SELECT IF(cel is null or cel='' or cel='-','',cel) as jh3 FROM `even` WHERE nam='" + who + "';");
  }

  public String Face(String who) {
    return super.LMDSimple(
        "select if(cli.face is null or cli.face='' or cli.face='-','',cli.face) as jh3 from evento as eve left join cliente as cli on eve.id_cliente=cli.id WHERE eve.nombre='"
            + who + "';");
  }

  public String Mail(String who) {
    return super.LMDSimple(
        "select if(cli.email is null or cli.email='' or cli.email='-','',cli.email) as jh3 from evento as eve left join cliente as cli on eve.id_cliente=cli.id WHERE eve.nombre='"
            + who + "';");
  }
}
