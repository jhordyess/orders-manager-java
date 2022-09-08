package core.LaTeX;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author jhordyess
 */
@WebServlet(name = "Delivery", urlPatterns = { "/Delivery" })
public class Delivery extends HttpServlet {

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
    response.setContentType("text/html;charset=UTF-8");
    try (PrintWriter out = response.getWriter()) {
      String lat = request.getParameter("lat");
      String lon = request.getParameter("lon");
      out.println("<!DOCTYPE html>");
      out.println("<html>");
      out.println("<head>");
      out.println("<title>Servlet Delivery</title>"
          + "<style>"
          + "body{"
          + "margin:0;padding:0"
          + "}"
          + "div#mapid{"
          + "height: 5cm;width: 9cm; display: inline-block;"
          + "}</style>"
          + "<link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.6.0/leaflet.css'/>"
          + "<script src='https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.6.0/leaflet.js'></script>"
          + "<script src='https://unpkg.com/leaflet-image@0.4.0/leaflet-image.js'></script>"
          + "</head>");
      out.println("<body>"
          + "<div id='mapid'></div>"
          + "<img id='img'></img>"
          + "<script>"
          + "let x = " + lat + ";"
          + "let y = " + lon + ";"
          + "let mymap = L.map('mapid',{"
          + "center: [x, y],"
          + "zoom: 16,"
          + "zoomControl:false,"
          + "preferCanvas: true,"
          // +
          // ",dragging:false,keyboard:false,scrollWheelZoom:false,boxZoom:false,doubleClickZoom:false"
          + "});"
          + "L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {"
          + "  attribution: '&copy; <a href=\"https://www.openstreetmap.org/copyright\">OpenStreetMap</a> contributors',"
          + "  maxZoom: 18"
          + "}).addTo(mymap);"
          // + "L.control.scale().addTo(mymap);"
          + "let marker = L.marker([x, y]).addTo(mymap);"

          + "leafletImage(mymap, function(err, canvas) {"
          + "let img = document.getElementById('img');"
          + "const dimensions = mymap.getSize();"
          + "img.width = dimensions.x;"
          + "img.height = dimensions.y;"
          + "img.src = canvas.toDataURL();"
          + "});"
          + "</script>");
      out.println("</body>");
      out.println("</html>");
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
