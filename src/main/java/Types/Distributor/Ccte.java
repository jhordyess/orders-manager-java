package Types.Distributor;

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
    arr.add(new Upload(this.getUpdate(), 1, "updist", false, this.getFrms(), true));
    arr.add(new Upload(this.getCreate(), 0, "nedist", false, this.getFrms(), false));
    arr.add(new Upload(this.elimina(), 50, "eldist", false, null, true));
    arr.add(new Upload(this.drorep(), 50, "elrdist", false, null, true));
    arr.add(new Upload(this.updateRem(), 50, "updistr", true, null, true));
    arr.add(new Upload(this.evento(), 50, "chdieve", false, null, true));
    arr.add(new Upload(this.representa(), 50, "chdir", true, null, true));
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

  public String representa() {
    return "RP";
  }

  public String evento() {
    return "EVS";
  }

  public String drorep() {
    return "ERRE";
  }

  @Override
  public String[] getFrms() {
    return "fsd-uml".split("-");
  }
}
