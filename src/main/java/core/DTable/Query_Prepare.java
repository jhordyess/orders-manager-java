package core.DTable;

/**
 *
 * @author jhordyess
 */
public class Query_Prepare {

  private final Server_Request srobj;
  private final String[] campos;
  private String sql;

  public Query_Prepare(Server_Request srobj, String[] campos) {
    this.srobj = srobj;
    this.campos = campos;
    this.sql = "";
  }

  public void setSelec(String tname) {
    this.sql = "SELECT ";
    for (int i = 0; i < this.campos.length; i++) {
      this.sql += this.campos[i];
      if (i != (this.campos.length - 1)) {
        this.sql += ",";
      }
    }
    this.sql += " FROM " + tname;
  }

  private String getWhere() {
    String str = "";
    if (this.srobj.schFilVal(false)) {
      str += " WHERE ";
    }
    while (this.srobj.schFilVal(true)) {
      String me = this.srobj.schFilVal();
      if (me.contains("&&")) {
        str += this.campos[(this.srobj.getFil_idx() - this.srobj.getIniEmpty())] + " BETWEEN '"
            + me.replace("&&", "' AND '") + "'";
      } else {
        str += this.campos[(this.srobj.getFil_idx() - this.srobj.getIniEmpty())] + " LIKE '%" + me + "%'";
      }
      if (this.srobj.schFilVal(false)) {
        str += " AND ";
      }
    }
    return str;
  }

  private void setOrder() {
    this.sql += " ORDER BY " + (this.srobj.getOrder().getColumn() - this.srobj.getIniEmpty()) + " "
        + this.srobj.getOrder().getDir();
  }

  private void setLimit() {
    this.sql += " LIMIT " + this.srobj.getStart() + "," + this.srobj.getLength();
  }

  public String runSetWhere(String tname) {
    this.setSelec(tname);
    String aux = this.getWhere();
    this.sql += aux;
    return "SELECT COUNT(*) AS 'jh3' FROM " + tname + aux + " LIMIT 1;";
  }

  public String endSql() {
    this.setOrder();
    this.setLimit();
    return this.sql + ";";
  }

  public static String count(String tname) {
    return "SELECT COUNT(*) AS 'jh3' FROM " + tname + " LIMIT 1;";
  }

}
