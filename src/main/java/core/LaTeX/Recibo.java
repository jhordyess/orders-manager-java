package core.LaTeX;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 *
 * @author jhordyess
 */
public class Recibo {

  private String out = "";

  public Recibo(String serie, String map, String or) {
    try {
      OwnDB sd = new OwnDB();
      String z = sd.checkExist(serie);
      if (!z.equals("")) {
        String[] line = sd.Recibi1(z);
        // cli,cel,fch,com,aco;
        String salir = "\\begin{center}"
            + "\\url{www.jhordyess.com}"
            + "\\end{center}"
            + "\\vspace{-0.5cm}\\textcolor{col3}{\\rule{\\linewidth}{1px}}\\\\"
            + "\\begin{minipage}{.28\\linewidth}"
            + "\\noindent\\begin{center}"
            + "\\scriptsize "
            + "Bolivia"
            + "\\end{center}"
            + "\\end{minipage}\\hfill"
            + "\\begin{minipage}[t]{.05\\linewidth}"
            + "\\begin{tabular}{@{}rc}"
            + "\\textbf{\\small Fecha:}&" + line[2] + "\\\\"
            + "\\textbf{\\small Nº:}&" + serie + ""
            + "\\end{tabular}"
            + "\\end{minipage}\\hfill"
            + "\\renewcommand{\\arraystretch}{1.2}\n"
            + "\\newline"
            + "\\begin{table}[t!]"
            + "\\small"
            + "\\begin{tabular}{@{}rc}"
            + "\\textbf{Cliente}&\\\\"
            + "Nombre:&" + line[0] + "\\\\"
            + "Celular:&" + line[1] + "\\\\"
            + "\\end{tabular}"
            + "\\end{table}";
        salir += "\\renewcommand{\\arraystretch}{1.2}"
            + "\\begin{table}[t!]"
            + "\\small"
            + "\\resizebox{\\linewidth}{!}{"
            + "\\begin{tabular}{P{4.5cm}P{1cm}P{1.5cm}P{1cm}P{1.5cm}}"// tabular
            + "\\cellcolor{col1}\\textbf{\\color{white}Descripción}&\\cellcolor{col1}\\textbf{\\color{white}Talla}&\\cellcolor{col1}\\textbf{\\color{white}Cant.}&\\cellcolor{col1}\\textbf{\\color{white}P/U}&\\cellcolor{col1}\\textbf{\\color{white}Total}\\\\";
        String tt = "\\tt ";
        String celda = "\\cellcolor{col2}";

        String[][] r = sd.Recibi2(z);
        double sum = 0;
        if (r.length > 0 && r[0].length == 4) {
          int ix = 1;
          for (String[] row : r) {
            double pu = Double.parseDouble(row[3]);
            int cnt = Integer.parseInt(row[2]);
            double c = round((cnt * pu), 1);
            sum = c + sum;
            if (ix % 2 == 0) {
              salir += tt + celda + row[0] + "&" + tt + celda + row[1] + "&" + tt + celda + cnt + "&" + tt + celda + pu
                  + "&" + tt + celda + c + "\\\\";
            } else {
              salir += tt + row[0] + "&" + tt + row[1] + "&" + tt + cnt + "&" + tt + pu + "&" + tt + c + "\\\\";
            }
            ix++;
          }
          for (int index = ix; index <= 6; index++) {
            if (index % 2 == 0) {
              salir += celda + "&" + celda + "&" + celda + "&" + celda + "&" + celda + "\\\\";
            } else {
              salir += "&&&&\\\\";
            }
          }
          if (ix > 6 && ix % 2 == 0) {
            salir += celda + "&" + celda + "&" + celda + "&" + celda + "&" + celda + "\\\\";
          }
        } else {
          for (int index = 1; index <= 6; index++) {
            if (index % 2 == 0) {
              salir += celda + "&" + celda + "&" + celda + "&" + celda + "&" + celda + "\\\\";
            } else {
              salir += "&&&&\\\\";
            }
          }
        }

        double acuenta = Double.parseDouble(line[4]), envio = Double.parseDouble(line[5]),
            desc = Double.parseDouble(line[6]);
        double total = sum + envio;
        total = round((total - (total * desc)), 1);
        String txt = "\\multicolumn{2}{l}{\\cellcolor{Turquoise}\\textbf{\\color{white}Total}}&\\cellcolor{Turquoise}\\textbf{\\color{white}"
            + round(total, 1) + "}\\\\";
        salir += "\\multicolumn{2}{l}{\\multirow{5}{*}{\\footnotesize\\begin{minipage}{5.5cm}"
            + (line[3].equals("-") ? "" : ("Nota: " + line[3])) + "\\end{minipage}}}&"
            + (envio == 0 && desc == 0 ? txt : ("\\multicolumn{2}{l}{Subtotal}&" + round(sum, 1) + "\\\\"))
            + (envio != 0 ? ("\\multicolumn{2}{l}{}&\\multicolumn{2}{l}{\\emph{Envio}}&" + round(envio, 1) + "\\\\")
                : "")
            + (desc != 0
                ? ("\\multicolumn{2}{l}{}&" + "\\multicolumn{2}{l}{\\emph{Descuento}}&" + ((int) (round(desc, 2) * 100))
                    + "\\%\\\\")
                : "")
            + (envio != 0 || desc != 0 ? ("\\multicolumn{2}{l}{}&" + txt) : "")
            + "\\multicolumn{2}{l}{}&\\multicolumn{2}{l}{\\emph{A cuenta}}&" + round(acuenta, 1) + "\\\\"
            + "\\multicolumn{2}{l}{}&\\multicolumn{2}{l}{\\cellcolor{Goldenrod}\\textbf{\\color{white}Saldo}}&\\cellcolor{Goldenrod}\\textbf{\\color{white}"
            + round((total - (acuenta)), 1) + "}\\\\"
            + "\\end{tabular}" + "}";
        salir += "\\end{table}"
            + "\\vspace{-.35em}\\textcolor{col3}{\\rule{\\linewidth}{1px}}\\\\\\footnotesize\\\\";
        if (map.equals("0")) {
          salir += "Tiempo de espera agotado, revise su velocidad de Internet e intente nuevamente.";
        } else if (map.equals("1")) {
          salir += "Problemas con el procesador del mapa.";
        } else if (!map.equals("") && map.endsWith(".png")) {
          salir += "\\center\\vspace{-0.5cm}\\includegraphics[width=9cm]{" + or + map + "}";
        }
        out = recibo(salir);
      } else {
        out = recibo("No puede obtener recibo!");
      }
    } catch (NumberFormatException e) {
      out = "";
    }
  }

  private String recibo(String vls) {
    return "\\documentclass[varwidth=10.5cm, border=.5cm,10pt]{standalone}\n"
        + "\\usepackage[utf8]{inputenc}\n"
        + "\\usepackage{lmodern}\n"
        + "\\usepackage{array}\n"
        + "\\newcolumntype{P}[1]{>{\\centering\\arraybackslash}p{#1}}\n"
        + "\\newcolumntype{L}[1]{>{\\arraybackslash}p{#1}}\n"
        + "\\usepackage{multirow}\n"
        + "\\usepackage[dvipsnames,svgnames]{xcolor}\n"
        + "\\definecolor{col1}{RGB}{110, 208, 247}\n"
        + "\\definecolor{col2}{RGB}{240, 245, 245}\n"
        + "\\definecolor{col3}{RGB}{70, 172, 220}\n"
        + "\\usepackage[pdftex]{graphicx}\n"
        + "\\usepackage[pdftex,pdfauthor={Jhordyess},pdftitle={Recibo},\n"
        + "pdfproducer={Latex with hyperref},pdfcreator={pdflatex}]{hyperref}\n"
        + "\\usepackage{colortbl}\n"
        + "\\begin{document}"
        + vls
        + "\\end{document}";
  }

  public String getOut() {
    return out;
  }

  private double round(double value, int places) {
    if (places < 0) {
      throw new IllegalArgumentException();
    }
    BigDecimal bd = BigDecimal.valueOf(value);
    bd = bd.setScale(places, RoundingMode.HALF_UP);
    return bd.doubleValue();
  }

}
