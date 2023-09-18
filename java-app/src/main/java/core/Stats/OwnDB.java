package core.Stats;

import com.google.gson.JsonArray;

/**
 *
 * @author jhordyess
 */
public class OwnDB extends core.Models.DBAOLD {
  public JsonArray getData(String type) {
    return super.LMDTwo((type.equals("0") ? "p_x_mes" : "p_x_semana"), null, "inf-tot-con".split("-"));
  }
}
