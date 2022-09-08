package core;

import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 *
 * @author jhordyess
 */
public class Functions {

  public static void show(PrintWriter out, String x) {
    out.println(x);
  }

  /**
   * fechas, permite obtener segun formato, una fecha.
   *
   * @param fom   Formato a realizar. ex: "dd/MM/yyyy HH:mm:ss"
   * @param fecha El objeto date para realizar.
   * @return String formateado
   */
  public static String fechPrint(String fom, Date fecha) {
    return (new SimpleDateFormat(fom, new Locale("es"))).format(fecha);
  }

  /**
   * fechas, permite obtener segun formato, una fecha
   *
   * @param fom   Formato a realizar. ex: "dd/MM/yyyy HH:mm:ss"
   * @param fecha Tiene que estar asi: dd-M-yyyy hh:mm:ss
   * @return String formateado
   */
  public static String fechPrint(String fom, String fecha) {
    return (new SimpleDateFormat(fom)).format(fechD(fecha));
  }

  /**
   * fechas, permite obtener en objeto date una fecha a partir de String.
   *
   * @param fecha Tiene que estar asi: dd-M-yyyy hh:mm:ss
   * @return Date del string dado.
   */
  public static Date fechD(String fecha) {
    Date x;
    try {
      x = (new SimpleDateFormat("dd-M-yyyy hh:mm:ss")).parse(fecha);
    } catch (NullPointerException | ParseException eDx) {
      x = (new Date());
    }
    return x;
  }

  /**
   * tStamp, permite obtener el valor en Time Stamp desde un estring.
   *
   * @param fecha Tiene que estar asi: dd-M-yyyy hh:mm:ss
   * @return String ya obtenido.
   */
  public static String tStamp(String fecha) {
    return ((new Timestamp(fechD(fecha).getTime())).getTime()) + "";
  }

  /**
   * ufechD, permite obtener el valor de Time Stamp hacia un formato
   *
   * @param unixT Tiempo unix en string.
   * @param form  Formato a realizar. ex: "dd/MM/yyyy HH:mm:ss"
   * @return String de formato: dd-M-yyyy
   */
  public static String ufechD(String unixT, String form) {
    return fechPrint(form, new Date((long) Long.parseLong(unixT) * 1000));
  }

  /**
   * Muestra los valores de una matriz bidimencional
   *
   * @param alfa Matrix bidimencional
   */
  public static void MostrarMatrix2(String[][] alfa) {
    for (String[] strings : alfa) {
      for (String string : strings) {
        System.out.print(string + ", ");
      }
      System.out.print("&");
    }
  }

  public static String makeS(String x) {
    x = x.replaceAll(Functions.latinUT(129), "Á");// 195 129
    x = x.replaceAll(Functions.latinUT(137), "É");// 195 137//NO EFICTIVO
    x = x.replaceAll(Functions.latinUT(141), "Í");// 195 141
    x = x.replaceAll(Functions.latinUT(145), "Ñ");// 195 145/NO VERIFICADO SI FUNCIONA
    x = x.replaceAll(Functions.latinUT(147), "Ó");// 195 147//NO VERIFICADO SI FUNCIONA
    x = x.replaceAll(Functions.latinUT(154), "Ú");// 195 154//NO VERIFICADO SI FUNCIONA
    x = x.replaceAll(Functions.latinUT(161), "á");// Ã¡//195 161
    x = x.replaceAll(Functions.latinUT(169), "é");// Ã©// 195 169
    x = x.replaceAll(Functions.latinUT(173), "í");// Â 195 173
    x = x.replaceAll(Functions.latinUT(179), "ó");// Ã³//195 179
    x = x.replaceAll(Functions.latinUT(177), "ñ");// Ã±//195 177
    x = x.replaceAll(Functions.latinUT(186), "ú");// Ãº 195 186
    return x;
  }

  public static String latinUT(int n) {
    /*
     * try{
     * String xx = "ú";
     * byte[] latin1 = xx.getBytes("UTF-8");
     * //byte[] utf8 = new String(latin1, "ISO-8859-1").getBytes("UTF-8");
     * String xp = new String(latin1, "ISO-8859-1");
     * } catch (UnsupportedEncodingException e) {
     * }
     */
    int m = 195;
    return (new Character((char) m).toString()) + (new Character((char) n).toString());
  }

  public static String[][] generos() {
    String[][] filters = { { "Unisex", "0" }, { "Hombre", "1" }, { "Mujer", "2" } };
    return filters;
  }

  public static String generos(String a) {
    String o = "";
    for (String[] strings : core.Functions.generos()) {
      if (strings[0].equals(a)) {
        o = strings[1];
        break;
      }
    }
    return o;
  }

  public static JsonArray generos(int x) {
    JsonArray ray = new JsonArray();
    JsonObject two = new JsonObject();
    Boolean tmp = false;
    two.add("txt", (new Gson()).toJsonTree("Unisex"));
    two.add("key", (new Gson()).toJsonTree("0"));
    if (x != -1 && x == 0 && !tmp) {
      two.add("act", (new Gson()).toJsonTree(true));
      tmp = true;
    }
    ray.add(two);
    two = new JsonObject();
    two.add("txt", (new Gson()).toJsonTree("Hombre"));
    two.add("key", (new Gson()).toJsonTree("1"));
    if (x != -1 && x == 1 && !tmp) {
      two.add("act", (new Gson()).toJsonTree(true));
      tmp = true;
    }
    ray.add(two);
    two = new JsonObject();
    two.add("txt", (new Gson()).toJsonTree("Mujer"));
    two.add("key", (new Gson()).toJsonTree("1"));
    if (x != -1 && x == 1 && !tmp) {
      two.add("act", (new Gson()).toJsonTree(true));
    }
    ray.add(two);
    return ray;
  }

  public static String booles(String a) {
    String o = "";
    for (String[] strings : core.Functions.booles()) {
      if (strings[0].equals(a)) {
        o = strings[1];
        break;
      }
    }
    return o;
  }

  public static String[][] booles() {
    String[][] filters = { { "No", "0" }, { "Si", "1" } };
    return filters;
  }

  public static JsonArray booles(int x) {
    JsonArray ray = new JsonArray();
    JsonObject two = new JsonObject();
    Boolean tmp = false;
    two.add("txt", (new Gson()).toJsonTree("No"));
    two.add("key", (new Gson()).toJsonTree("0"));
    if (x != -1 && x == 0 && !tmp) {
      two.add("act", (new Gson()).toJsonTree(true));
      tmp = true;
    }
    ray.add(two);
    two = new JsonObject();
    two.add("txt", (new Gson()).toJsonTree("Si"));
    two.add("key", (new Gson()).toJsonTree("1"));
    if (x != -1 && x == 1 && !tmp) {
      two.add("act", (new Gson()).toJsonTree(true));
    }
    ray.add(two);
    return ray;
  }

  public static String[] combine(String[] a, String[] b) {
    int len = a.length + b.length;
    String out[] = new String[len];
    System.arraycopy(a, 0, out, 0, a.length);
    System.arraycopy(b, 0, out, a.length, b.length);
    return out;
  }

  /**
   * Obtiene el valor de un item dentro un Json Array
   * Se resuelve el caso donde se tenga un null
   * 
   * @param tmp
   * @param i
   * @return
   */
  public static String JAtoStr(JsonArray tmp, int i) {
    return tmp.get(i).isJsonNull() ? "" : tmp.get(i).getAsString();
  }
}
