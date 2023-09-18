package Types.Customer;

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
    arr.add(new Upload(this.getUpdate(), 1, "upclien", false, this.getFrms(), true));
    arr.add(new Upload(this.getCreate(), 0, "neclien", false, this.getFrms(), false));
    arr.add(new Upload(this.elimina(), 50, "elclien", false, null, true));
    arr.add(new Upload(this.updateRem(), 50, "upclienR", true, null, true));

    arr.add(new Upload(this.distrib(), 10, "clidist", false, this.getFr1(), true));
    arr.add(new Upload(this.evento(), 10, "clieven", false, this.getFr1(), true));
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

  public String evento() {
    return "CEE";
  }

  public String distrib() {
    return "DMM";
  }

  @Override
  public String[] getFrms() {
    return "fsd-uml-cel-eml-fas-rew".split("-");
  }

  public String[] getFr1() {
    return "usd-rem".split("-");
  }
}
