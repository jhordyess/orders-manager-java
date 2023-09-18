package core.LaTeX;

import java.util.Arrays;
import java.util.Iterator;
import com.google.gson.Gson;

/**
 *
 * @author jhordyess
 */
public class Itinerario {

  private String out = "";

  public Itinerario(String series) {// ? values or all
    OwnDB ddbb = new OwnDB();
    try {
      String salida = "";
      int contador = 0;
      if (series == null) {

      }
      String[] Arrseries = (new Gson()).fromJson(series, String[].class);
      Iterator<String> iterator = Arrays.asList(Arrseries).iterator();
      while (iterator.hasNext()) {
        String recibo = iterator.next();
        String id = ddbb.checkExist(recibo);
        if (!id.equals("")) {
          contador++;
          String[] reg = ddbb.iterar1(id);
          String nombre = reg[0];
          String celular = reg[1];
          String ci = reg[2];
          String destino = reg[3];
          String comentario = reg[4];
          String total = reg[5];
          String acuenta = reg[6];
          salida += "\\begin{table}[t!]"
              + "\\resizebox{\\linewidth}{!}{"
              + "\\begin{tabular}{|p{4cm}p{4cm}p{3.4cm}p{3.4cm}|p{3.5cm}|}"
              + "\\hline\n"
              + "\\multicolumn{2}{|l}{\\textbf{Nombre:} " + nombre + "}& \\textbf{Cel:} " + celular
              + " & \\textbf{CI:} " + ci + "  &\\multirow{5}{*}{"
              + "\\begin{minipage}{3.25cm}"
              + "\\textbf{Nombre:}\\\\"
              + "" + nombre + "\\\\"
              + "\\textbf{Destino:}\\\\"
              + "" + destino + "\\\\"
              + "\\textbf{Recibo Nro:}\\\\"
              + "" + recibo + "\\\\[.15cm]"
              + "\\textbf{Detalle:}\\\\"
              + "" + comentario + ""
              + "\\end{minipage}"
              + "}\\\\"
              + "\\multicolumn{2}{|l}{\\textbf{Destino:} " + destino + "} &\\multicolumn{2}{l|}{\\textbf{Recibo Nro:} "
              + recibo + "}&\\\\ \\cline{1-4}"
              + "\\multicolumn{4}{|c|}{";
          String[][] detalles = ddbb.Recibi2(id);
          int nxs = detalles.length;
          if (nxs > 0 && nxs < 13) {// 12 tuplas sin titulo
            int contar = 1;
            salida += "\\begin{tabular}{p{3cm}p{3cm}p{3cm}}"
                + "\\textbf{Código} &\\textbf{Talla}&\\textbf{Cant.}  \\\\ ";
            for (String[] detalle : detalles) {
              salida += "" + detalle[0] + " & " + detalle[1] + " & " + detalle[2] + "\\\\ ";
              contar++;
            }
            while (contar < 13) {// max 12 tuplas
              salida += "& & \\\\ ";
              contar++;
            }
            salida += "\\end{tabular} ";
          } else if (nxs > 12 && nxs < 25) {// max 24 tuplas
            int contar = 1;
            salida += "\\begin{tabular}{p{1.5cm}p{1.5cm}p{1.5cm} c p{1.5cm}p{1.5cm}p{1.5cm}}"
                + "\\textbf{Cod.} &\\textbf{Talla} &\\textbf{Cant.} &&\\textbf{Cod.} &\\textbf{Talla} &\\textbf{Cant.}  \\\\ ";
            for (int i = 0; i < detalles.length; i++) {
              String[] detalle = detalles[i];
              salida += "" + detalle[0] + " & " + detalle[1] + " & " + detalle[2];
              contar++;
              if ((detalles.length - 1) != i) {
                salida += "& &" + detalle[0] + " & " + detalle[1] + " & " + detalle[2];
                i++;
              } else {
                salida += "& &  &  & ";
              }
              salida += "\\\\";
            }
            while (contar < 13) {// ? max 24 tuplas
              salida += "& & && & &\\\\ ";
              contar++;
            }
            salida += "\\end{tabular} ";
          } else if (nxs > 24) {
            salida += "\\begin{tabular}{p{3cm}p{3cm}p{3cm}}"
                + "\\multicolumn{3}{c}{Alerta, se supero los 24 pedidos maximos para imprimir}\\\\"
                + "&& \\\\ && \\\\ && \\\\ && \\\\ && \\\\ && \\\\ && \\\\ && \\\\ && \\\\ && \\\\ && \\\\ && \\\\"
                + "\\end{tabular} ";
          } else {
            salida += "\\begin{tabular}{p{3cm}p{3cm}p{3cm}}"
                + "\\multicolumn{3}{c}{Error, el detalle de su pedido no es correcto}\\\\"
                + "&& \\\\ && \\\\ && \\\\ && \\\\ && \\\\ && \\\\ && \\\\ && \\\\ && \\\\ && \\\\ && \\\\ && \\\\"
                + "\\end{tabular} ";
          }
          Double sald = Double.parseDouble(total) - Double.parseDouble(acuenta);
          salida += "}&\\\\\\cline{1-4}"
              + " \\multicolumn{4}{|l|}{\\textbf{Detalle:} " + comentario + "}&\\\\"
              + "" + "& \\textbf{A cuenta:} " + acuenta + "  & \\textbf{Saldo:} " + sald + " & \\textbf{Total:} "
              + total + "&\\\\\\hline"
              + " \\end{tabular}}"
              + "\\end{table}";
          if (contador % 3 == 0) {
            salida += "\\clearpage";
          }
        }

      }

      if (contador % 3 != 0) {
        salida += "$\\bigtriangledown$";
      }
      out = esquema(salida);
    } catch (NumberFormatException e) {
      out = "";
      System.out.println("LaTex error: " + e.getMessage());
    }
  }

  private String esquema(String par) {
    return "\\documentclass[letter,11pt]{article}\n"
        + "\\usepackage[utf8]{inputenc}\n"
        + "\\usepackage[margin=.5cm]{geometry}\n"
        + "\\usepackage{multirow}\n"
        + "\\usepackage[pdftex]{graphicx}\n"
        + "\\usepackage[pdftex,\n"
        + "pdfauthor={Jhordyess},\n"
        + "pdftitle={Itinerario}," + System.getProperty("line.separator")
        + "pdfproducer={Latex with hyperref},\n"
        + "pdfcreator={pdflatex}]{hyperref}\n"
        + "\\begin{document}\n"
        + "\\pagestyle{empty}\n"
        + "\\noindent\n"
        + par
        + "\\end{document}";
  }

  public String getOut() {
    return out;
  }
}
