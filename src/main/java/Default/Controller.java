package Default;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.concurrent.TimeUnit;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author jhordyess
 */
@WebServlet(name = "main", urlPatterns = { "/main" })
public class Controller extends HttpServlet {

  /**
   * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
   * methods.
   *
   * @param request  servlet request
   * @param response servlet response
   * @throws ServletException if a servlet-specific error occurs
   * @throws IOException      if an I/O error occurs
   */
  protected void processRequest(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    /*
     * response.setContentType("text/html;charset=UTF-8");
     * response.setHeader("Access-Control-Allow-Origin", "*");
     * response.setHeader("Access-Control-Allow-Credentials", "true");
     * response.setHeader("Access-Control-Allow-Methods",
     * "POST, GET, HEAD, OPTIONS");
     * response.setHeader("Access-Control-Allow-Headers",
     * "Origin, Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers"
     * );
     */
    try (PrintWriter out = response.getWriter()) {
      // request.getContextPath()
      String sal = "Null!";
      int mls = 0;
      if (null != request.getParameter("mm")) {
        response.setContentType("application/json");
        response.setHeader("Cache-Control", "no-store");
        View ne = new View();
        sal = ne.getMenu(request.getContextPath()).toString();
      }
      try {
        TimeUnit.MILLISECONDS.sleep(mls);
      } catch (InterruptedException e) {
        sal = "Block!";
      }
      out.println(sal);
      out.flush();
      out.close();
    }
  }

  // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
  // + sign on the left to edit the code.">
  /**
   * Handles the HTTP <code>GET</code> method.
   *
   * @param request  servlet request
   * @param response servlet response
   * @throws ServletException if a servlet-specific error occurs
   * @throws IOException      if an I/O error occurs
   */
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    processRequest(request, response);
  }

  /**
   * Handles the HTTP <code>POST</code> method.
   *
   * @param request  servlet request
   * @param response servlet response
   * @throws ServletException if a servlet-specific error occurs
   * @throws IOException      if an I/O error occurs
   */
  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    processRequest(request, response);
  }

  /**
   * Returns a short description of the servlet.
   *
   * @return a String containing servlet description
   */
  @Override
  public String getServletInfo() {
    return "Short description";
  }// </editor-fold>

}
