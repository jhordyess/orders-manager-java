package core.Models;

import core.DataBase.Model.Upload;
import static core.Infos.MsgModel;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 *
 * @author jhordyess
 */
public class DBAModel {

  /**
   * Instancia del objeto Connection de la libreria java.sql
   */
  private Connection conn;
  private String msg;

  /**
   * Se obtiene los nombres de columnas desde la DB. Considerado un LMD.
   *
   * @param table tabla a buscar.
   * @return Arreglo con los nombres.
   */
  private String[] LMDCols(String table) {
    String out = "";
    try {
      this.open_connection();
      ResultSet rs = this.conn.createStatement().executeQuery("SHOW COLUMNS FROM " + table + ";");
      while (rs.next()) {
        out += rs.getString(1) + "-";
      }
      this.close_connection();
    } catch (SQLException ex) {
      MsgModel(ex.getMessage());
    } catch (Exception exs) {
      MsgModel(exs.getMessage());
    }
    try {
      return out.substring(0, (out.length() - 1)).split("-");
    } catch (Exception e) {
      MsgModel(e.getMessage());
      return null;
    }
  }

  /**
   * Consulta LMD que obtiene un resultado en una sola columna y fila. Note que
   * la consulta debe tener a la columna con el nombre 'jh3'
   *
   * @param sql Consulta a la DB.
   * @return Valor cadena.
   */
  protected String LMDSimple(String sql) {
    String out = "";
    try {
      this.open_connection();
      ResultSet rs = this.conn.createStatement().executeQuery(sql);
      if (rs.next()) {
        out = rs.getString("jh3");
      }
      this.close_connection();
    } catch (SQLException ex) {
      MsgModel(ex.getMessage());
    } catch (Exception exs) {
      MsgModel(exs.getMessage());
    }
    return out;
  }

  protected JsonObject LMDList(int empty, core.DTable.Server_Request srobj, String view) {
    srobj.setIniEmpty(empty);
    core.DTable.Query_Prepare alfa = new core.DTable.Query_Prepare(srobj, this.LMDCols(view));
    JsonObject result = new JsonObject();
    result.add("recordsFiltered", (new Gson()).toJsonTree(Integer.parseInt(this.LMDSimple(alfa.runSetWhere(view)))));
    String sql = alfa.endSql();
    result.add("recordsTotal",
        (new Gson()).toJsonTree(Integer.parseInt(this.LMDSimple(core.DTable.Query_Prepare.count(view)))));
    JsonArray ray = new JsonArray();
    try {
      this.open_connection();
      ResultSet rs = this.conn.createStatement().executeQuery(sql);
      int c = rs.getMetaData().getColumnCount();
      while (rs.next()) {
        JsonArray ja = new JsonArray();
        for (int i = 0; i < empty; i++) {
          ja.add("");
        }
        for (int j = 0; j < c; j++) {
          ja.add(rs.getString((j + 1)));
        }
        ray.add(ja);
      }
      this.close_connection();
      result.add("data", ray);
      return result;
    } catch (SQLException | NumberFormatException exs) {
      MsgModel(exs.getMessage());
      return null;
    }
  }

  private void open_connection() {
    this.setMsg("");
    Map<String, String> env = System.getenv();
    String db_host = env.get("PMA_HOST") + ":" + "3306";
    String db_user = env.get("DB_USER");
    String db_pass = env.get("MARIADB_ROOT_PASSWORD");
    String db_name = env.get("MARIADB_DATABASE");
    String url = "jdbc:mysql://" + db_host + "/" + db_name;
    try {
      Class.forName("com.mysql.jdbc.Driver");
      this.conn = DriverManager.getConnection(url, db_user, db_pass);
    } catch (ClassNotFoundException e) {
      MsgModel(e.getMessage());
    } catch (SQLException ex) {
      this.setMsg(ex.getMessage());
      MsgModel(ex.getMessage());
    } catch (Exception exs) {
      MsgModel(exs.getMessage());
    }
  }

  private void close_connection() {
    try {
      this.conn.close();
    } catch (SQLException ex) {
      this.setMsg(ex.getMessage());
      MsgModel(ex.getMessage());
    } catch (Exception exs) {
      MsgModel(exs.getMessage());
    }
  }

  /**
   * Permite consultar a la base de datos acerca actualizacion de registros.
   *
   * @param ky
   * @param val
   * @param nets
   * @return Objeto JSON convertido a cadena.
   */
  public String LDDUpds(String ky, String val, java.util.ArrayList<Upload> nets) {
    JsonObject tst = new JsonObject();
    Boolean ou = false;
    try {
      ou = true;
      for (String string : (new core.DataBase.Query_Prepare()).Update(ky, val, nets).split(";")) {
        ou = ou && this.LDD(string + ";");
      }
    } catch (Exception e) {
      MsgModel(e.getMessage());
    }
    if (!ou) {
      tst.add("sw", (new Gson()).toJsonTree(0));
      tst.add("msg", (new Gson()).toJsonTree("".equals(this.getMsg()) ? "Peticion inaceptable" : this.getMsg()));
    } else {
      tst.add("sw", (new Gson()).toJsonTree(1));
    }
    return tst.toString();
  }

  public String updateD(String tname) {// DATE_FORMAT(UPDATE_TIME, '%e-%m-%Y %T')
    return this.LMDSimple(
        "SELECT UNIX_TIMESTAMP(UPDATE_TIME) AS 'jh3' FROM information_schema.tables WHERE TABLE_SCHEMA = '"
            + System.getenv().get("MARIADB_DATABASE") + "' AND TABLE_NAME = '"
            + tname + "' LIMIT 1;");
  }

  /**
   * Función para ejecutar una consulta de manupulacion de datos.
   *
   * @param sSQL Consulta de SQL
   * @return La consulta fue satisfactoria?
   */
  protected Boolean LDD(String sSQL) {
    // MsgModel(sSQL);
    Boolean ts = false;
    try {
      this.open_connection();
      PreparedStatement pst = conn.prepareStatement(sSQL);
      // aca se puede intentar usar setstring (es decir usar ? ? ? ?)...pero el modelo
      // cambiaria...
      int n = pst.executeUpdate();
      this.close_connection();
      ts = (n != 0);
    } catch (SQLException ex) {
      this.setMsg(ex.getMessage());
      MsgModel(ex.getMessage());
    } catch (Exception exs) {
      MsgModel(exs.getMessage());
    }
    return ts;
  }

  /**
   * Compone una consulta LMD en un arreglo, del tipo 1xn o nx1.
   *
   * @param SP nombre de procedimiento.
   * @param co puede ser null.
   * @return Arreglo de cadenas.
   */
  protected JsonArray LMDOne(String SP, String co) {
    JsonArray ray = new JsonArray();
    try {
      this.open_connection();
      co = (co != null && !co.equals("")) ? "'" + co + "'" : "";
      ResultSet rs = this.conn.createStatement().executeQuery("CALL " + SP + "(" + co + ");");
      int c = rs.getMetaData().getColumnCount();
      if (c == 1) {
        while (rs.next()) {
          ray.add(rs.getString((0 + 1)));
        }
      } else {
        if (rs.next()) {
          for (int j = 0; j < c; j++) {
            ray.add(rs.getString((j + 1)));
          }
        } else {
          throw new UnsupportedOperationException("No searchable");
        }
      }
      this.close_connection();
      return ray;
    } catch (SQLException | NumberFormatException exs) {
      MsgModel(exs.getMessage());
      return null;
    }
  }

  /**
   * Compone una consulta LMD en un arreglo, cuyo objetos que lo componen tienen
   * las propiedades segun el arreglo de cadenas enviada.
   *
   * @param SP nombre de procedimiento.
   * @param co puede ser null.
   * @param z  propiedades para cada objeto.
   * @return Arreglo de objectos JSON.
   */
  protected JsonArray LMDTwo(String SP, String co, String[] z) {
    JsonArray ray = new JsonArray();
    try {
      this.open_connection();
      co = (co != null && !co.equals("")) ? "'" + co + "'" : "";
      ResultSet rs = this.conn.createStatement().executeQuery("CALL " + SP + "(" + co + ");");
      int c = rs.getMetaData().getColumnCount();
      if (c == z.length) {
        while (rs.next()) {
          JsonObject um = new JsonObject();
          for (int j = 0; j < c; j++) {
            um.add(z[j], (new Gson()).toJsonTree(rs.getString((j + 1))));
          }
          ray.add(um);
        }
      } else {
        throw new UnsupportedOperationException("No aceptable");
      }
      this.close_connection();
      return ray;
    } catch (SQLException | NumberFormatException exs) {
      MsgModel(exs.getMessage());
      return null;
    }
  }

  public String getMsg() {
    return msg;
  }

  private void setMsg(String msg) {
    this.msg = msg;
  }

  /**
   * Función para ejecutar una SP de manipulacion de datos.Deben llamarse name y
   * code. Idealmente seran empleados solo para llenar en SubKeys. Y filtros.
   *
   * @param SP
   * @param co
   * @param x  Si se marcara como activo
   * @return
   */
  protected JsonArray LMDSkeys(String SP, String co, int x) {
    JsonArray ray = new JsonArray();
    JsonObject two;
    try {
      this.open_connection();
      co = (co != null && !co.equals("")) ? "'" + co + "'" : "";
      ResultSet rs = this.conn.createStatement().executeQuery("CALL " + SP + "(" + co + ");");
      if (rs.getMetaData().getColumnCount() == 2) {
        Boolean tmp = false;
        while (rs.next()) {
          two = new JsonObject();
          two.add("txt", (new Gson()).toJsonTree(rs.getString("name")));
          two.add("key", (new Gson()).toJsonTree(rs.getString("code")));
          if (x != -1 && (x + 1) == rs.getRow() && !tmp) {
            two.add("act", (new Gson()).toJsonTree(true));
            tmp = true;
          }
          ray.add(two);
        }
      }
      this.close_connection();
      return ray;
    } catch (SQLException | NumberFormatException exs) {
      MsgModel(exs.getMessage());
      return null;
    }
  }
}
