package core.DataBase.Model;

/**
 * 
 * @author jhordyess
 */
public class Upload {

  private final String code;
  private final int n;// cantidad select requerida
  private final String SP;
  private final Boolean se;// usar select?
  private final Boolean sw;// usar sub code
  private final String[] in;// usar los input?

  /**
   * @param code
   * @param n    Cantidad de seleccionados
   * @param SP   Nombre de procedimiento almacenado
   * @param sw   Se usara el subcodigo?
   * @param in   codigos para los inpus. Null si no se usa.
   * @param se   Se usara los select?
   */
  public Upload(String code, int n, String SP, Boolean sw, String[] in, Boolean se) {
    this.code = code;
    this.n = n;
    this.SP = SP;
    this.sw = sw;
    this.in = in;
    this.se = se;
  }

  public String getCode() {
    return code;
  }

  public int getN() {
    return n;
  }

  public String getSP() {
    return SP;
  }

  public Boolean getSw() {
    return sw;
  }

  public String[] getIn() {
    return in;
  }

  public Boolean getSe() {
    return se;
  }
}
