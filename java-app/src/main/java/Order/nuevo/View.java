package Order.nuevo;

/**
 *
 * @author jhordyess
 */
public class View extends core.Models.DBAOLD {

  public String[] getClientes() {
    return super.LMDOne("lst_clien", null);
  }

  public String getAClientes() {// ? se debe enviar de una cantidad de: 6 elementos x n
    return super.LMDTwo("p_clien", null, "nombre-ci-celular-email-face".split("-")).toString();
  }

  public String[] getDistribuidores() {
    return super.LMDOne("lst_dist", null);
  }

  public String[] getEventos() {
    return super.LMDOne("lst_even", null);
  }

  public String[] getTallas() {
    return super.LMDOne("p_tallas", null);
  }

  public String[] getContacto() {
    return super.LMDOne("s_pContac", null);
  }

  public String[] getDestino() {
    return super.LMDOne("s_pDestin", null);
  }

  public String[] getPagosF() {
    return super.LMDOne("s_pPay", null);
  }
}
