package core.Models;

import static core.Infos.MsgModel;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Map;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 *
 * @author jhordyess
 */
public class DBAOLD {

  private Connection conn;
  private String msg;

  public String getMsg() {
    return this.msg;
  }

  private void setMsg(String msg) {
    this.msg = msg;
  }

  private void open_connection() {
    this.setMsg("");
    Map<String, String> env = System.getenv();
    String db_host = env.get("DB_HOST") + ":" + "3306";
    String db_user = env.get("DB_USER");
    String db_pass = env.get("DB_PASSWORD");
    String db_name = env.get("DB_NAME");
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
      MsgModel("Error al cerrar: " + ex.getMessage());
    } catch (Exception exs) {
      MsgModel("Error al cerrar: " + exs.getMessage());
    }
  }

  protected String[][] LMD(String sSQL) {
    String[][] registro = null;
    try {
      this.open_connection();
      Statement st = conn.createStatement();
      ResultSet rs = st.executeQuery(sSQL);
      // TODO Query once for count rows
      int r = this.rows(conn.createStatement().executeQuery(sSQL));
      int c = cols(rs);
      registro = new String[r][c];
      int i = 0;
      while (rs.next()) {
        for (int j = 0; j < c; j++) {
          registro[i][j] = rs.getString((j + 1));
        }
        i++;
      }
      this.close_connection();
    } catch (SQLException ex) {
      this.setMsg(ex.getMessage());
      MsgModel("Error con LMD: " + ex.getMessage());
    } catch (Exception exs) {
      MsgModel("Error con LMD: " + exs.getMessage());
    }
    return registro;
  }

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
      this.setMsg(exs.getMessage());
      MsgModel(exs.getMessage());
      return null;
    }
  }

  protected Boolean LDD(String sSQL) {
    // System.out.println(sSQL);
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
    return !(!ts && !this.getMsg().equals(""));
  }

  protected String LMDSimple(String sql) {
    // System.out.println(sql);
    String out = "";
    try {
      this.open_connection();
      ResultSet rs = this.conn.createStatement().executeQuery(sql);
      if (rs.next()) {
        out = rs.getString("jh3");
      }
      this.close_connection();
    } catch (SQLException ex) {
      this.setMsg(ex.getMessage());
      MsgModel(ex.getMessage());
    } catch (Exception exs) {
      MsgModel(exs.getMessage());
    }
    return out;
  }

  protected String[] LMDOne(String SP, String co) {
    String[] ray;
    int i = 0;
    try {
      this.open_connection();
      co = (co != null && !co.equals("")) ? "'" + co + "'" : "";
      ResultSet rs = this.conn.createStatement().executeQuery("CALL " + SP + "(" + co + ");");
      // TODO Ibidem
      int r = this.rows(this.conn.createStatement().executeQuery("CALL " + SP + "(" + co + ");"));
      ray = new String[r];
      while (rs.next()) {
        ray[i] = (rs.getString(1));
        i++;
      }
      this.close_connection();
      return ray;
    } catch (SQLException | NumberFormatException exs) {
      this.setMsg(exs.getMessage());
      MsgModel(exs.getMessage());
      return null;
    }
  }

  // <editor-fold defaultstate="collapsed" desc="Funciones que permiten obtener el
  // tamaño de la consulta generada">
  private int rows(ResultSet xp) {
    int t = 0;
    try {
      while (xp.next()) {
        t = t + 1;
      }
    } catch (SQLException ex) {
      MsgModel("Error contando filas: " + ex.getMessage());
    } catch (Exception exs) {
      MsgModel("Error contando filas: " + exs.getMessage());
    }
    return t;
  }

  private int cols(ResultSet xp) {
    int t = 0;
    try {
      t = xp.getMetaData().getColumnCount();// resultsetmetadata
    } catch (SQLException ex) {
      MsgModel("Error contando columnas: " + ex.getMessage());
    } catch (Exception exs) {
      MsgModel("Error contando columnas: " + exs.getMessage());
    }
    return t;
  }

  // </editor-fold>
}
