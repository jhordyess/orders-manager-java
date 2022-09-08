package Xtra.Places;

import core.DataBase.Model.General;
import core.DataBase.Model.Upload;
import java.util.ArrayList;

/**
 *
 * @author jhordyess
 */
public final class Ccte implements General {

  @Override
  public ArrayList<Upload> getArr() {
    ArrayList<Upload> arr = new ArrayList<Upload>();
    arr.add(new Upload(this.getUpdate(), 1, "upyDestR", false, this.getFrms(), true));
    arr.add(new Upload(this.getCreate(), 0, "neoDest", false, this.getFrms(), false));
    arr.add(new Upload(this.elimina(), 50, "delDest", false, null, true));
    arr.add(new Upload(this.updateRem(), 50, "mpvDestR", true, null, true));
    return arr;
  }

  @Override
  public String getReads() {
    return "LP";
  }

  @Override
  public String getUpdate() {
    return "UP";
  }

  @Override
  public String getCreate() {
    return "NEO";
  }

  public String elimina() {
    return "ER";
  }

  public String updateRem() {
    return "UPR";
  }

  @Override
  public String[] getFrms() {
    return "fsd-uml".split("-");
  }
}
