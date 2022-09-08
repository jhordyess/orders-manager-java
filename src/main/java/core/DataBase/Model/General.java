package core.DataBase.Model;

import java.util.ArrayList;

/**
 *
 * @author jhordyess
 */
public interface General {

  /**
   * Obtener las consultas para Manejar la DB.
   */
  public ArrayList<Upload> getArr();

  /**
   * Obtener Nombres clave para los inputs
   */
  public String[] getFrms();

  public String getReads();

  public String getUpdate();

  public String getCreate();
}
