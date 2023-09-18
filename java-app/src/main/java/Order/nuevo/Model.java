package Order.nuevo;

import java.util.Arrays;
import java.util.Iterator;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;

/**
 *
 * @author jhordyess
 */
public class Model extends core.Models.DBAOLD {

  public String Update(String notused, String val) {
    JsonObject jobjeto = (new Gson()).fromJson(val, JsonObject.class);
    String id = pedido(jobjeto.get("pedido").toString());
    Boolean zz;
    zz = tipo(jobjeto.get("tipo").toString(), id);
    if (zz) {
      zz = detalle(jobjeto.get("detalle").toString(), id) && estado(jobjeto.get("estado").toString(), id);
    }
    JsonObject tst = new JsonObject();
    if (zz) {
      tst.add("recc", (new Gson())
          .toJsonTree(super.LMDSimple("select recibo_nro as jh3 from pedido where id=" + id + " limit 1;")));
      tst.add("sw", (new Gson()).toJsonTree(1));// super.LDDUpds(ky, val, new Ccte().getArr());
    } else {
      tst.add("sw", (new Gson()).toJsonTree(0));// super.LDDUpds(ky, val, new Ccte().getArr());
      tst.add("msg", (new Gson()).toJsonTree(super.getMsg()));
    }
    return tst.toString();
  }

  private Boolean tipo(String objecto, String dona) {// el id
    JsonObject dd = (new Gson()).fromJson(objecto, JsonObject.class);
    String ql;
    if (dd.has("t-e_nombre")) {// es evento
      ql = "call pedir_evele(" + dona + ",'" + dd.get("t-e_nombre").getAsString() + "',"
          + dd.get("t-e_sw").getAsString()
          + ")";
    } else if (dd.has("t-n_nombre")) {// es algo normal
      String cii = dd.get("t-n_ci").getAsString();
      cii = cii.equals("") ? "null" : ("'" + cii + "'");
      String cel = dd.get("t-n_cel").getAsString();
      cel = cel.equals("") ? "null" : ("'" + cel + "'");
      String face = dd.get("t-n_face").getAsString();
      face = face.equals("") ? "null" : ("'" + face + "'");
      String EMA = dd.get("t-n_email").getAsString();
      EMA = EMA.equals("") ? "null" : ("'" + EMA + "'");
      String SW = dd.get("t-n_sw").getAsString();
      String dds = dd.has("t-n-d_name") ? ("'" + dd.get("t-n-d_name").getAsString()) + "'" : "null";
      String des = dd.has("t-n-e_name") ? ("'" + dd.get("t-n-e_name").getAsString()) + "'" : "null";
      ql = "call pedir_nor(" + dona + ",'" + dd.get("t-n_nombre").getAsString() + "'," + cii + "," + cel + "," + face
          + ","
          + EMA + "," + SW + "," + des + "," + dds + ")";
    } else if (dd.has("t-d_nombre")) {// es es distribuidor
      ql = "call pedir_dist(" + dona + ",'" + dd.get("t-d_nombre").getAsString() + "'," + dd.get("t-d_sw").getAsString()
          + ")";
    } else {
      ql = null;
    }
    if (ql != null) {
      return super.LDD(ql);
    } else {
      return false;
    }
  }

  private String pedido(String objecto) {
    JsonObject dd = (new Gson()).fromJson(objecto, JsonObject.class);
    String deli = dd.get("p-delivery").getAsString().replaceAll(" ", "").replace(",", " ");
    return super.LMDSimple(
        "call nd_ped('" + dd.get("p-rcb").getAsString() + "','" + dd.get("p-contacto").getAsString() + "','"
            + dd.get("p-destino").getAsString() + "','" + dd.get("p-pagos").getAsString() + "','"
            + dd.get("p-enviar").getAsString()
            + "','" + dd.get("p-comm1").getAsString() + "','" + dd.get("p-comm2").getAsString() + "','" + deli + "',"
            + dd.get("p-desc").getAsString() + "," + dd.get("p-acont").getAsString() + ","
            + dd.get("p-ext").getAsString() + ");");
  }

  private Boolean estado(String objecto, String dona) {
    JsonObject dd = (new Gson()).fromJson(objecto, JsonObject.class);
    String segundo = dd.get("e-aprorec").getAsString();
    String cuarto = dd.get("e-enviado").getAsString();
    // estrategia, eliminar con el id, asi este no exista luego para todo hago
    // insert
    String da = "call nd_estado(" + dona + ",'" + dd.get("e-entrante").getAsString() + "',"
        + (segundo.equals("") ? "null" : ("'" + segundo + "'")) + ","
        + (cuarto.equals("") ? "null" : ("'" + cuarto + "'")) + "," + dd.get("e-cancel").getAsString() + ");";
    return super.LDD(da);
  }

  private Boolean detalle(String objecto, String dona) {
    super.LDD("DELETE FROM detalle where id_pedido=" + dona + ";"); // estrategia, eliminar con el id,
                                                                    // asi este no exista luego para todo
                                                                    // hago insert
    Boolean z;
    try {
      z = true;
      JsonObject[] strArrObjs = (new Gson()).fromJson(objecto, JsonObject[].class);
      Iterator<JsonObject> iterator = Arrays.asList(strArrObjs).iterator();
      while (iterator.hasNext()) {
        JsonObject dd = iterator.next();
        String jeje = "call nd_detalle(" + dona + ",'" + dd.get("d-code").getAsString() + "','"
            + dd.get("d-talla").getAsString()
            + "','" + dd.get("d-cant").getAsString() + "','" + dd.get("d-unit").getAsString() + "')";
        z = z && super.LDD(jeje + ";");
      }
    } catch (Exception e) {
      z = false;
    }
    return z;
  }

  public String Detail(String key) {// ? para indicar que no es nada, debe enviarse vacio
    JsonArray js = new JsonArray();
    if (!key.equals("")) {
      String id = super.LMDSimple("select id as jh3 from pedido where recibo_nro='" + key + "'");
      js = super.LMDTwo("recib_p2", id, "codigo-talla-cantidad-precio".split("-"));
    }
    return js.toString();
  }
  // aca incluye la delivery mas

  public String[] Fondos(String key) {
    if (!key.equals("")) {
      return super.LMD("call get_ped_1('" + key + "')")[0];// EXTRA,ACUENTA,CONTACTO,DESTINO,MEDIO DE
                                                           // PAGO,COMENTARIO1,COMENTARIO2,FECHA PARA ENVIAR,COORDENADAS
    } else {
      String[] seras = { "", "", "", "", "", "", "", "", "", "0.00" };// 0.00
      return seras;
    }
  }

  // ? SIEMPRE ENVIAR VACIO SI NO HAY
  public String[] Estados(String key) {// ENTRANTE-(FECHA RECHAZADA O ACEPTADA)-TERMINADO-ENVIADO-rechazado -
                                       // cancelado,
    if (!key.equals("")) {
      String id = super.LMDSimple("select id as jh3 from pedido where recibo_nro='" + key + "'");
      // String[] seras = {"", "", "", "", "1", ""};//su ausencia significa que no
      // tiene acuenta!
      return super.LMD("call get_ped_s(" + id + ");")[0];
    } else {
      String[] seras = { "", "", "", "", "", "" };// su ausencia significa que no tiene acuenta!
      return seras;
    }
  }

  public String[] cliValues(String key) {// 8-9-10-11
    if (!key.equals("")) {
      // String[] sera = {"nombre", "-", "-", "", "", "0", "evento1", "", "", "", "",
      // ""};//respeta los vacios!!!!!
      // String[] sera1 = {"nombre", "-", "-", "", "", "0", "", "", "", "", "",
      // ""};//respeta los vacios!!!!!
      // String[] sera2 = {"", "-", "-", "", "", "", "", "", "ds", "1", "",
      // ""};//respeta los vacios!!!!! y al 1 en los recordar.
      String id = super.LMDSimple("select id as jh3 from pedido where recibo_nro='" + key + "'");
      // String[] seras = {"", "", "", "", "1", ""};//su ausencia significa que no
      // tiene acuenta!
      return super.LMD("call get_ped_t(" + id + ");")[0];
    } else {
      String[] seram = { "", "", "", "", "", "", "", "", "", "", "", "" };// respeta los vacios!!!!!no debe enviarse
                                                                          // nulos u otros
      // nombre,carnet,celular,email,usuario de facebook,recordar,es evento,
      // distribuidor
      // y luego si de evento-recordar o de distribuidor-recordar
      return seram;
    }
  }
}
