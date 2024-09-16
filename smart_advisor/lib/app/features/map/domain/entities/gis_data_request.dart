class GISDataRequest {
  double lat;
  double lon;

  GISDataRequest({required this.lat, required this.lon});

  toMap() => {"x": lon, "y": lat};
}
