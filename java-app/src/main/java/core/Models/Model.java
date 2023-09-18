package core.Models;

import core.DTable.Server_Request;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 *
 * @author jhordyess
 */
public interface Model {

  public JsonObject ReadAll(Server_Request srobj, String fly);

  public String UpdateDate();

  public String Update(String ky, String val);

  public JsonArray Read(String co);
}
