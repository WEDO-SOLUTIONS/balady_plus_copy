enum ServiceAction {
  pageRoute(type: "page");

  const ServiceAction({required this.type});
  final String type;
}
