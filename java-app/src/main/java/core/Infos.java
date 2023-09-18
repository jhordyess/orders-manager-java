package core;

/**
 *
 * @author jhordyess
 */
public class Infos {

  public static void Mesagge(String msg) {
    System.out.println(msg);
  }

  public static void MsgControl(String msg) {
    Mesagge("Control say: " + msg);
  }

  public static void MsgModel(String msg) {
    Mesagge("Model say: " + msg);
  }

  public static void MsgView(String msg) {
    Mesagge("View say: " + msg);
  }
}
