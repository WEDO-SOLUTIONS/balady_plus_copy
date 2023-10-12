enum ServiceAction {
  pageRoute(type: "page"),
  cardsPage(type: "cards"),
  dialog(type: "dialog"),
  webview(type: "webview");

  const ServiceAction({required this.type});
  final String type;
}
