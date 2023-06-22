class Env{
  static const debug = String.fromEnvironment("DEBUG", defaultValue: "false") != "false";
  static const local = String.fromEnvironment("LOCAL", defaultValue: "false") != "false";
  static const appTitile = "MakChat";
  static const scheme = local?"http":"https";
  static const wsScheme = local?"ws":"wss";
  static const host = local?
    String.fromEnvironment("REMOTE_ADDR", 
      defaultValue: String.fromEnvironment("REMOTE_ADDR_CP",
        defaultValue: "127.0.0.1"
      )
    ):"makchat.ru";
  static const port = local?5000:null;
}