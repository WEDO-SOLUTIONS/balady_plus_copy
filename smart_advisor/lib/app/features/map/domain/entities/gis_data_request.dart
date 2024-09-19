class GISDataRequest {
  double lat;
  double lon;

  GISDataRequest({required this.lat, required this.lon});

  // Converts the object to a map
  Map<String, dynamic> toMap() => {
        "x": lon, // Assuming 'x' corresponds to longitude
        "y": lat // Assuming 'y' corresponds to latitude
      };

  // Factory constructor to create an instance from a map
  factory GISDataRequest.fromMap(Map<String, dynamic> map) {
    return GISDataRequest(
      lat: map['y'], // Assuming 'y' in the map corresponds to latitude
      lon: map['x'], // Assuming 'x' in the map corresponds to longitude
    );
  }
}
