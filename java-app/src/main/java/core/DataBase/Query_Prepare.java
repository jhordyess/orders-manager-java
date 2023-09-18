package core.DataBase;

import core.DataBase.Model.Upload;
import java.util.ArrayList;
import com.google.gson.JsonElement;

/**
 *
 * @author jhordyess
 */
public class Query_Prepare {

  public String Update(String ky, String val, ArrayList<Upload> nets) {
    String ou = "";
    core.DataBase.Server_Request xp = new core.DataBase.Server_Request(val);
    for (Upload net : nets) {
      if (net.getN() >= xp.selects.size() && net.getCode().equals(ky)) {
        if (net.getN() == 0 && !net.getSe()) {
          ou = this.makeg(net.getSP(), subsis(net, xp));
        } else {
          for (JsonElement select : xp.selects) {
            ou += this.makeg(net.getSP(), (net.getSe() ? ("'" + select.getAsString() + "',") : "") + subsis(net, xp));
          }
        }
        break;
      }
    }
    return ou;
  }

  private String subsis(Upload net, core.DataBase.Server_Request xp) {
    String o = net.getSw() ? "'" + (String) xp.value + "'," : "";
    if (net.getIn() != null && net.getIn().length > 0) {
      for (String zz : net.getIn()) {
        if (!zz.equals("") && !zz.equals(" ")) {
          String aun = (String) xp.getInput(zz);
          if (!aun.equals(" ")) {
            o += "'" + aun + "',";
          }
        }
      }
    }
    return o;
  }

  private String makeg(String SP, String vals) {
    if (SP.contains(";") || vals.contains(";")) {
      throw new UnsupportedOperationException("Ilegal query");
    }
    vals = vals.substring(0, (vals.length() - 1));// quitar la coma
    return ("CALL " + SP + "(" + vals + ");");
  }
}
