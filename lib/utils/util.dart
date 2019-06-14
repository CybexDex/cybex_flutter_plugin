class Utils {
  static String wrapId(String id, String type) {
    if (id.contains(".")) {
      return id;
    }

    if (type == "asset") {
      return "1.3." + id;
    } else if (type == "account") {
      return "1.2." + id;
    }
    return id;
  }
}

const ASSET = "asset";
const ACCOUNT = "account";
