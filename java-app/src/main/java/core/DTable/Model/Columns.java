package core.DTable.Model;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 *
 * @author jhordyess
 */
public class Columns {

  private final List<Column> column;

  public Columns() {
    this.column = new ArrayList<Column>();
  }

  public List<Column> getColumn() {
    return column;
  }

  public void addColumn(Column column) {
    this.column.add(column);
  }

  @Override
  public String toString() {
    return Arrays.toString(this.column.toArray());
  }

  public class Column {

    private String data;
    private String name;
    private Boolean searchable;
    private Boolean orderable;
    private Search search;

    public Column(String data, String name, Boolean searchable, Boolean orderable, String value, Boolean rejex) {
      this.data = data;
      this.name = name;
      this.searchable = searchable;
      this.orderable = orderable;
      this.search = new Search(value, rejex);
    }

    public String getData() {
      return data;
    }

    public void setData(String data) {
      this.data = data;
    }

    public String getName() {
      return name;
    }

    public void setName(String name) {
      this.name = name;
    }

    public Boolean getSearchable() {
      return searchable;
    }

    public void setSearchable(Boolean searchable) {
      this.searchable = searchable;
    }

    public Boolean getOrderable() {
      return orderable;
    }

    public void setOrderable(Boolean orderable) {
      this.orderable = orderable;
    }

    public Search getSearch() {
      return search;
    }

    public void setSearch(Search search) {
      this.search = search;
    }

    @Override
    public String toString() {
      return "[" + this.getData() + ", "
          + this.getName() + ", "
          + String.valueOf(this.getSearchable()) + ", "
          + String.valueOf(this.getOrderable()) + ","
          + this.getSearch() + "]";
    }
  }
}
