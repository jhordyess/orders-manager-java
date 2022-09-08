package Order.estado;

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
    arr.add(new Upload(this.getUpdate(), 1, "upyPayR", false, this.getFrms(), true));
    arr.add(new Upload(this.getCreate(), 0, "neoPay", false, this.getFrms(), false));
    arr.add(new Upload(this.elimina(), 50, "delpp", false, null, true));
    arr.add(new Upload(this.terminar(), 50, "terpp", false, null, true));
    arr.add(new Upload(this.enviar(), 50, "envpp", false, null, true));
    arr.add(new Upload(this.enviarS(), 50, "aco_envpp", false, null, true));
    arr.add(new Upload(this.Salar(), 50, "aco_empty", false, null, true));
    arr.add(new Upload(this.cancelar(), 50, "cncpp", false, this.getCanc(), true));
    arr.add(new Upload(this.pendiar(), 50, "pndpp", false, null, true));
    arr.add(new Upload(this.devolver(), 50, "dtrpp", false, null, true));
    arr.add(new Upload(this.updateRem1(), 50, "mvmed", true, null, true));
    arr.add(new Upload(this.updateRem2(), 50, "mvdes", true, null, true));
    arr.add(new Upload(this.updateRem3(), 50, "mvpay", true, null, true));
    return arr;
  }

  public String getReads(int x) {
    if (x >= 0 && x < 5) {
      String[] zz = this.getReads().split("-");
      return zz[x];
    } else {
      return null;
    }
  }

  @Override
  public String getReads() {
    return "PE-PP-PV-PD-PC";
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
    return "DRP";
  }

  public String terminar() {
    return "TRM";
  }

  public String enviar() {
    return "ENB";
  }

  public String enviarS() {
    return "ENBS";
  }

  public String Salar() {
    return "SABS";
  }

  public String cancelar() {
    return "CNC";
  }

  public String pendiar() {
    return "PND";
  }

  public String devolver() {
    return "DVV";
  }

  public String updateRem1() {
    return "MMC";
  }

  public String updateRem2() {
    return "MLD";
  }

  public String updateRem3() {
    return "MMP";
  }

  @Override
  public String[] getFrms() {// ? no usado aun
    return "fsd-uml".split("-");
  }

  public String[] getCanc() {
    return "cgn".split("-");
  }
}
