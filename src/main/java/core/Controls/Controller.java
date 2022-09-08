package core.Controls;

import core.DTable.Server_Request;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author jhordyess
 */
public class Controller {

  private final HttpServletRequest req;
  private int delays = 0;
  private String val;
  private String sim;

  public Controller(HttpServletRequest req) {
    this.req = req;
  }

  /**
   * Cuando RDServer .js pide para componer vista.
   *
   * @return
   */
  public Boolean isNavigation() {
    try {
      this.val = this.param("nav");
      return null != this.val;
    } catch (Exception e) {
      return false;
    }
  }

  /**
   * Cuando DataTable .js pide datos.
   *
   * @return
   */
  public Boolean isRead() {
    try {
      this.val = this.param("who");
      if (null != this.val) {
        this.delays = 100;
        return true;
      } else {
        return false;
      }
    } catch (Exception e) {
      return false;
    }
  }

  public Server_Request getRequest() {
    return (new Server_Request(this.req));
  }

  /**
   * Cuando Select .js pide para componer vista y otros.
   *
   * @return
   */
  public Boolean isUpdateView() {
    try {
      this.val = this.param("ky");
      this.sim = this.param("ds");
      return null != this.param("tt") && null != this.val && null != this.sim;
    } catch (Exception e) {
      return false;
    }
  }

  public Boolean isUpdateModel() {
    try {
      this.val = this.param("ky");
      this.sim = this.param("dd");
      if (null != this.param("tt") && null != this.val && null != this.sim) {
        this.delays = 100;// 750
        return true;
      } else {
        return false;
      }
    } catch (Exception e) {
      return false;
    }
  }

  public Boolean isSync() {
    try {
      this.val = this.param("ref");
      this.sim = this.param("dtd");
      return null != this.param("tt") && null != this.val && null != this.sim;
    } catch (Exception e) {
      return false;
    }
  }

  private String param(String str) {
    return this.req.getParameter(str);
  }

  public int getDelays() {
    return delays;
  }

  public String getVal() {
    return val;
  }

  public String getSim() {
    return sim;
  }

  public void setDelays(int delays) {
    this.delays = delays;
  }
}
