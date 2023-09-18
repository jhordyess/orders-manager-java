package core.DTable.Model;

public class Search {

  private String value;
  private Boolean rejex;

  public Search() {
    this.value = null;
    this.rejex = null;
  }

  public Search(String value, Boolean rejex) {
    this.value = value;
    this.rejex = rejex;
  }

  public String getValue() {
    return value;
  }

  public void setValue(String value) {
    this.value = value;
  }

  public Boolean getRejex() {
    return rejex;
  }

  public void setRejex(Boolean rejex) {
    this.rejex = rejex;
  }

  @Override
  public String toString() {
    return "[" + this.getValue() + ", " + String.valueOf(this.getRejex()) + "]";
  }
}
