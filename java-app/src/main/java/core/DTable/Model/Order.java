package core.DTable.Model;

/**
 *
 * @author jhordyess
 */
public class Order {

  private int column;
  private String dir;

  public Order() {
    this.column = -1;
    this.dir = null;
  }

  public Order(int column, String dir) {
    this.column = column;
    this.dir = dir;
  }

  public String getDir() {
    return dir;
  }

  public void setDir(String dir) {
    this.dir = dir;
  }

  public int getColumn() {
    return column;
  }

  public void setColumn(int column) {
    this.column = column;
  }

  @Override
  public String toString() {
    return "[" + this.getColumn() + ", " + this.getDir() + "]";
  }
}
