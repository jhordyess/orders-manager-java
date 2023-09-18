package core.DTable;

import core.DTable.Model.Order;
import core.DTable.Model.Columns;
import java.util.Enumeration;
import javax.servlet.http.HttpServletRequest;

/* INFO : cuando usas la opcion hide, esta sigue siendo parte de la consulta a servidor, solo desde frontend se oculta
  draw cantidad de consultas realizadas...
  columns[i][data] id referencial..., depende del atributo data en Datatable, asi este representa al key del array
  columns[i][name] atributo name
  columns[i][searchable] si es buscable
  columns[i][orderable] si es ordenable
  columns[i][search][value] es el valor a consultar en la columna
  columns[i][search][regex] ?????????
  order[0][column] columna a ordenar
  order[0][dir] la forma(asc)(desc)
  search[value] es el valor general a consultar, si es null es que no hay
  search[regex] ?????????
  length es la cantidad de elementos que debe mostrarse...
  start es la posicion de la cual deberias mostrarle, respetando la cantidad que te dijo...
  _ es la hora de consulta en formato unix, solo metodo get
 */
/**
 * 
 * @author jhordyess
 */
public class Server_Request {

  private int draw = 0;
  private int length = 0;
  private int start = 0;
  // private Search search = new Search();
  private Order order = new Order();
  private Columns columns = new Columns();
  private int iniEmpty = 0;
  // **--**//
  private int fil_idx = -1;// ? apuntador en la columna que tenga filtro...

  public Server_Request(HttpServletRequest req) {
    this.draw = Integer.parseInt(req.getParameter("draw"));
    this.length = Integer.parseInt(req.getParameter("length"));
    this.start = Integer.parseInt(req.getParameter("start"));
    Enumeration<String> parameterNames = req.getParameterNames();
    while (parameterNames.hasMoreElements()) {
      String paramName = parameterNames.nextElement();
      String aux_now;
      try {
        aux_now = paramName.substring(0, paramName.indexOf('['));
      } catch (java.lang.StringIndexOutOfBoundsException s) {
        aux_now = paramName;
      }
      /*
       * if (aux_now.equals("search")) {
       * this.search.setValue(req.getParameter(paramName));
       * this.search.setRejex(Boolean.parseBoolean(req.getParameter(parameterNames.
       * nextElement())));
       * }
       */
      if (aux_now.equals("order")) {// OJO QUE ORDER ENVIA TAMBIEN UN PARAMETRO 0
        this.order.setColumn(Integer.parseInt(req.getParameter(paramName)) + 1);// dado que para consultar en sql,
                                                                                // empieza desde 1
        this.order.setDir(req.getParameter(parameterNames.nextElement()));
      }
      if (aux_now.equals("columns")) {
        this.columns.addColumn(columns.new Column(
            req.getParameter(paramName),
            req.getParameter(parameterNames.nextElement()),
            Boolean.parseBoolean(req.getParameter(parameterNames.nextElement())),
            Boolean.parseBoolean(req.getParameter(parameterNames.nextElement())),
            req.getParameter(parameterNames.nextElement()),
            Boolean.parseBoolean(req.getParameter(parameterNames.nextElement()))));
      }
    }
  }

  public int getDraw() {
    return draw;
  }

  public int getLength() {
    return length;
  }

  public int getStart() {
    return start;
  }

  /*
   * public Search getSearch() {
   * return search;
   * }
   */
  public Order getOrder() {
    return order;
  }

  public Columns getColumns() {
    return columns;
  }

  public int getIniEmpty() {
    return iniEmpty;
  }

  private int getSizeCols() {
    return this.getColumns().getColumn().size();
  }

  @Override
  public String toString() {
    return "Sorry, empty result!";
  }

  public int getFil_idx() {
    return fil_idx;
  }

  public String schFilVal() {
    try {
      return this.getColumns().getColumn().get(this.getFil_idx()).getSearch().getValue();
    } catch (IndexOutOfBoundsException e) {
      return null;
    } catch (Exception e) {
      return null;
    }
  }

  public Boolean schFilVal(Boolean sw) {
    int size = this.getSizeCols();
    int i;
    for (i = (this.fil_idx + 1); i < size; i++) {
      if (!this.getColumns().getColumn().get(i).getSearch().getValue().equals("")) {
        break;
      }
    }
    if (i >= size) {// ? significa que busco todo y no hay
      if (sw) {
        this.fil_idx = size;
      }
      return false;
    } else {
      if (sw) {
        this.fil_idx = i;
      }
      return true;
    }
  }

  public void setIniEmpty(int iniEmpty) {
    this.iniEmpty = iniEmpty;
  }
}
