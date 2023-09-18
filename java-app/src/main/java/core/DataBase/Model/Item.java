package core.DataBase.Model;

/**
 *
 * @author jhordyess
 */
public class Item {

  private final String nombre;
  private final String clase;
  private final String tipo;
  private final String val;
  private final String key;
  private final String[] opts;

  public Item(String nombre, String clase, String tipo, String val, String key, String[] opts) {
    this.nombre = nombre;
    this.clase = clase;
    this.tipo = tipo;
    this.val = val;
    this.key = key;
    this.opts = opts;
  }

  public String getNombre() {
    return nombre;
  }

  public String getClase() {
    return clase;
  }

  public String getTipo() {
    return tipo;
  }

  public String getVal() {
    return val;
  }

  public String getKey() {
    return key;
  }

  public String[] getOpts() {
    return opts;
  }

}
