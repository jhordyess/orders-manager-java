package Detail.Produc;

import static core.Infos.MsgControl;
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
@WebServlet(urlPatterns = { "/pro" })
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
    try (PrintWriter out = response.getWriter()) {
      String sal = "Null!";
      core.Controls.Controller cpu = new core.Controls.Controller(request);
      if (cpu.isUpdateView()) {
        try {
          sal = (new View().UpdateFormat(cpu.getVal(), cpu.getSim()));
        } catch (Exception e) {
          MsgControl(e.getMessage());
        } finally {
          response.setContentType("application/json");
          response.setCharacterEncoding("UTF-8");
        }
      } else if (cpu.isUpdateModel()) {
        try {
          sal = (new Model()).Update(cpu.getVal(), cpu.getSim());
        } catch (Exception e) {
          MsgControl(e.getMessage());
        } finally {
          response.setContentType("application/json");
          response.setCharacterEncoding("UTF-8");
        }
      } else if (cpu.isRead()) {
        try {
          sal = (new Model()).ReadAll(cpu.getRequest(), cpu.getVal()).toString();
        } catch (Exception e) {
          MsgControl(e.getMessage());
        } finally {
          cpu.setDelays(0);
          response.setContentType("application/json");
          response.setHeader("Cache-Control", "no-store");
          response.setCharacterEncoding("UTF-8");
        }
      } else if (cpu.isNavigation()) {
        try {
          request.setAttribute("com", request.getContextPath() + "/pro");
          request.setAttribute("data", (new View()).ReadFormat(cpu.getVal()));
          request.getRequestDispatcher("/design/crud/read_delete.jsp").forward(request, response);
        } catch (IOException | ServletException | NullPointerException e) {
          MsgControl(e.getMessage());
        }
      }
      try {
        TimeUnit.MILLISECONDS.sleep(cpu.getDelays());
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
