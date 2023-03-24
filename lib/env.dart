class Env{
  static const debug = String.fromEnvironment("DEBUG", defaultValue: "false") != "false";
  static const local = String.fromEnvironment("LOCAL", defaultValue: "false") != "false";
  static const appTitile = "MakChat";
  static const scheme = local?"http":"https";
  static const wsScheme = local?"ws":"wss";
  static const host = local?"127.0.0.1":"makchat1.loca.lt";
  static const port = local?5000:null;
}