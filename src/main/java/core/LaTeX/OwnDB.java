package core.LaTeX;

/**
 *
 * @author jhordyess
 */
public class OwnDB extends core.Models.DBAOLD {

  public String checkExist(String alpha) {
    return super.LMDSimple(
        "select id as jh3 from ped_gral2 where recib='" + alpha + "' and (estado=2 or estado=4 or estado=5) limit 1;");
  }

  public String[] Recibi1(String alpha) {
    return super.LMD("CALL recib_p1(" + alpha + ");")[0];
  }

  public String[][] Recibi2(String alpha) {
    return super.LMD("CALL recib_p2(" + alpha + ");");
  }

  public String[] getGeolocation(String alpha) {
    return super.LMD("call get_geon('" + alpha + "');")[0];
  }

  public String[] iterar1(String alpha) {
    return super.LMD("CALL item_p1(" + alpha + ");")[0];
  }
}
