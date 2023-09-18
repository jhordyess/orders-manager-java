package Types.Event;

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
    arr.add(new Upload(this.getUpdate(), 1, "upeven", false, this.getFrms(), true));
    arr.add(new Upload(this.getCreate(), 0, "neeven", false, this.getFrms(), false));
    arr.add(new Upload(this.elimina(), 50, "eleven", false, null, true));
    arr.add(new Upload(this.drorep(), 50, "elreven", false, null, true));
    arr.add(new Upload(this.updateRem(), 50, "upevenr", true, null, true));
    arr.add(new Upload(this.distrib(), 50, "chevdi", false, null, true));
    arr.add(new Upload(this.representa(), 50, "chrep", true, null, true));
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

  public String distrib() {
    return "DST";
  }

  public String drorep() {
    return "ERRE";
  }

  @Override
  public String[] getFrms() {
    return "fsd-uml".split("-");
  }
}
