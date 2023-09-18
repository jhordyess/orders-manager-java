package Detail.Produc;

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
    arr.add(new Upload(this.getUpdate(), 1, "upprro", false, this.getFfrms(), true));
    arr.add(new Upload(this.getCreate(), 0, "neprro", false, this.getFfrms(), false));
    arr.add(new Upload(this.elimina(), 24, "elprro", false, null, true));
    arr.add(new Upload(this.reclas(), 24, "elcls", false, null, true));
    arr.add(new Upload(this.updateRem(), 50, "buprro", true, null, true));
    arr.add(new Upload(this.darTag(), 50, "prtg", false, this.getFr2(), true));
    arr.add(new Upload(this.clase(), 50, "prcls", true, null, true));
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

  public String darTag() {
    return "CEE";
  }

  public String reclas() {
    return "RCC";
  }

  public String clase() {
    return "DIM";
  }

  public String[] getFfrms() {
    return core.Functions.combine(core.Functions.combine(this.getFrms(), this.getFr1()), this.getFr2());
  }

  public String[] getFf2() {
    return core.Functions.combine(this.getFrms(), this.getFr1());
  }

  @Override
  public String[] getFrms() {
    return "fsd-uml-cel".split("-");
  }

  public String[] getFr1() {
    return "usd-rem".split("-");
  }

  public String[] getFr2() {
    return "tgs".split("-");
  }
}
