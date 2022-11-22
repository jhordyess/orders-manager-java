package core.LaTeX;

import static core.Infos.MsgControl;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.Writer;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.microsoft.playwright.Playwright;
import com.microsoft.playwright.Browser;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.ElementHandle;
import java.nio.file.Paths;

/**
 *
 * @author jhordyess
 */
@WebServlet(name = "PDF", urlPatterns = { "/LaTeX" })
public class PDF extends HttpServlet {

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
    // 1. Prepare the .tex file
    String type = this.esquema_tex("vacio"), mapImage = "";
    switch (request.getParameter("s")) {
      case "1":
        OwnDB database = new OwnDB();
        String[] cuatro = database.getGeolocation(request.getParameter("t"));
        if (!cuatro[0].equals("") && !cuatro[1].equals("")) {
          mapImage = this.makeNode("http://localhost:8080/" + request.getContextPath() + "/" + "Delivery?" + "lat="
              + cuatro[0] + "&lon=" + cuatro[1] + "");
        }
        String comp = (new Recibo(request.getParameter("t"), mapImage, this.myTemp_Path(true))).getOut();
        if (!comp.equals("")) {
          type = comp;
        }
        break;
      case "2":
        String comps = (new Itinerario(request.getParameter("t"))).getOut();
        if (!comps.equals("")) {
          type = comps;
        }
        break;
    }
    // 2. Create the .tex file
    this.createTEX(type);
    // 3. Compile and show PDF
    if (this.compilateTEX() == 1) {
      this.viewPDF(response);
    } else {
      this.err(response);
    }
    // 4. Eliminar residuos
    this.dropExtras(mapImage);
  }

  private final String filename = this.random(5);

  private void createTEX(String math) {
    Writer writer;
    try {
      writer = new OutputStreamWriter(new FileOutputStream(this.getFilePath("tex", true)), StandardCharsets.UTF_8);
      writer.write(math, 0, math.length());
      writer.close();
    } catch (IOException ex) {
      MsgControl(ex.getMessage());
    }
  }

  private int compilateTEX() {
    List<String> dd = new ArrayList<>();
    if (this.isWindows())
      new Exception("Windows not supported");
    dd.add(this.isUnix() ? "pdflatex" : "");
    dd.add("-synctex=1");
    dd.add("-interaction=nonstopmode");
    dd.add("-halt-on-error");
    dd.add("-output-directory");
    dd.add(this.myTemp_Path(false));
    dd.add(this.getFilePath("tex", true));
    return this.proceso(dd, 5, "pdflatex", false);
  }

  private void viewPDF(HttpServletResponse respuesta) throws IOException {
    try (FileInputStream entrada = new FileInputStream(new File(this.getFilePath("pdf", true)));
        OutputStream salida = respuesta.getOutputStream()) {
      respuesta.setContentType("application/pdf");
      respuesta.addHeader("Content-Disposition", "inline; filename=" + "Jhordyess" + ".pdf");
      // ? PARA DESCARGAR
      // response.addHeader("Content-Disposition", "attachment; filename=" +
      // this.filename + ".pdf");
      // response.setContentLength((int) pdfFile.length());
      int bytes;
      while ((bytes = entrada.read()) != -1) {
        salida.write(bytes);
      }
      entrada.close();
      salida.flush();
      salida.close();
    } catch (IOException e) {
      this.err(respuesta);
      MsgControl(e.getMessage());
    }
  }

  private void dropExtras(String mapa) {
    try {
      String alfa = "";
      alfa += cleanFile("pdf", true) ? "pdf " : "";
      alfa += cleanFile("log", true) ? "log " : "";
      alfa += cleanFile("tex", true) ? "tex " : "";
      alfa += cleanFile("aux", true) ? "aux " : "";
      alfa += cleanFile("out", true) ? "out " : "";
      alfa += cleanFile("synctex.gz", true) ? "synctex.gz " : "";
      alfa += (!mapa.equals("") && !mapa.equals("0") && !mapa.equals("1") && cleanFile(mapa, false)) ? (mapa + " ")
          : "";
      if (!"".equals(alfa)) {
        MsgControl("Extras borrados: Todos, salvo " + alfa);
      }
    } catch (IOException e) {
      MsgControl(e.getMessage());
    }
  }

  private int proceso(List<String> comandos, /* Boolean to_temp, */ int waiting, String name, Boolean ver_out) {
    ProcessBuilder pb = new ProcessBuilder(comandos);
    int sw;
    /*
     * if (to_temp) {
     * pb.directory(new File(System.getProperty("java.io.tmpdir")));
     * }
     */
    try {
      Process p = pb.start();
      ConsolePrinter in = new ConsolePrinter(p.getInputStream(), ver_out);
      ConsolePrinter out = new ConsolePrinter(p.getErrorStream(), ver_out);
      new Thread(in).start();
      new Thread(out).start();
      if (!p.waitFor(waiting, TimeUnit.SECONDS)) {
        MsgControl("Proceso " + name + ": timeout");
        sw = 0;
        p.destroy();
      } else {
        sw = 1;
        p.destroy();
      }
    } catch (IOException | InterruptedException | SecurityException | IllegalArgumentException
        | NullPointerException t) {
      MsgControl("Proceso " + name + ", Exception: " + t.getMessage());
      sw = -1;
    }
    return sw;
  }

  private void err(HttpServletResponse response) throws IOException {
    response.setContentType("text/html;charset=UTF-8");
    try (PrintWriter out = response.getWriter()) {
      out.print("<h1><center>Dificultades tecnicas, intente nuevamente</center></h1>");
      out.close();
    }
  }

  /**
   * Se añade implicitamente el punto despues del nombre
   *
   * @param url Ex: "http://localhost:8080"
   */
  private String makeNode(String url) {
    String ran = this.random(5) + "." + "png";
    try (Playwright playwright = Playwright.create()) {
      Browser browser = playwright.chromium().launch();
      Page page = browser.newPage();
      page.navigate(url);
      ElementHandle canva = page.waitForSelector("#img");
      canva.screenshot(new ElementHandle.ScreenshotOptions().setPath(Paths.get(this.getFilePath(ran, false))));
      return ran;
    } catch (Exception ex) {
      System.out.println("LaTex error: " + ex.getMessage());
      return "1";
    }
  }

  private String esquema_tex(String x) {
    return "\\documentclass[varwidth=10.5cm, border=.5cm,10pt]{standalone}\\usepackage[utf8]{inputenc}\\begin{document}"
        + x + "\\end{document}";
  }

  // <editor-fold defaultstate="collapsed" desc="Mis funciones extras">
  /**
   * Generar una cadena alfanumerica, de forma aleatoria.
   *
   * @param cantidad Cantidad de caracteres a entregar
   */
  private String random(int cantidad) {
    String cadena_Alfa = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstvwxyz";
    String cade_AlfaNumerico = cadena_Alfa + "0123456789";
    StringBuilder builder = new StringBuilder();
    for (int i = 0; i <= cantidad; i++) {
      int character;
      if (i == 0) {
        character = (int) (Math.random() * cadena_Alfa.length());
      } else {
        character = (int) (Math.random() * cade_AlfaNumerico.length());
      }
      builder.append(cade_AlfaNumerico.charAt(character));
    }
    return builder.toString();
  }

  private Boolean cleanFile(String str, Boolean sw) throws IOException {
    return (!Files.deleteIfExists(new File(this.getFilePath(str, sw)).toPath()));
  }

  /**
   * Obtencion del path necesario.
   *
   * @param esPropio true, indica que se use el nombre general.
   * @param nombre   cadena de nombre de archivo*
   */
  private String getFilePath(String nombre, Boolean esPropio) {
    return this.myTemp_Path(false) + (esPropio ? (this.filename + "." + nombre) : nombre);
  }

  // Considerar el tipo de sistema operativo.
  private String getOs() {
    return System.getProperty("os.name").toLowerCase();
  }

  public boolean isWindows() {
    return (this.getOs().contains("win"));
  }

  public boolean isUnix() {
    String OS = this.getOs();
    return (OS.contains("nix") || OS.contains("nux") || OS.indexOf("aix") > 0);
  }

  /**
   * @param sw Si es verdadero, y se trata de windows, se reemplaza el backslash
   *           por backslash invertido
   */
  private String myTemp_Path(Boolean sw) {
    String man = System.getProperty("java.io.tmpdir");
    if (this.isWindows()) {
      new Exception("Windows not supported");
    } else if (this.isUnix()) {
      man = man + File.separator;
    } else {
      man = null;
      MsgControl("Sin compatibildad de OS: " + this.getOs());
    }
    return man;
  }
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="Muestra mensaje de consola ">

  class ConsolePrinter implements Runnable {
    // ?
    // http://labs.excilys.com/2012/06/26/runtime-exec-pour-les-nuls-et-processbuilder/
    private final InputStream inputStream;
    private final boolean i_print;
    private String value;

    ConsolePrinter(InputStream inputStream, boolean print) {
      this.inputStream = inputStream;
      this.i_print = print;
      this.value = "--BEGIN MESSAGE--\n";
    }

    @Override
    public void run() {
      BufferedReader br = new BufferedReader(new InputStreamReader(this.inputStream));
      try {
        while ((br.readLine()) != null) {
          if (this.i_print) {
            this.value += "\t" + br.readLine() + "\n";
          }
        }
      } catch (IOException e) {
        this.value = e.getMessage();
      } finally {
        if (this.i_print) {
          MsgControl(this.value + "--END MESSAGE--");
        }
      }
    }
  } // </editor-fold>
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
