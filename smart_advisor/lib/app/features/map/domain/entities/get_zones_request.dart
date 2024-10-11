class GetZonesRequest {
  int serviceTypeId;
  double longitude;
  double latitude;
  int? buffer;
  int activityId;

  // Constructor
  GetZonesRequest({
    required this.serviceTypeId,
    required this.longitude,
    required this.latitude,
    required this.activityId,
    this.buffer,
  });

  // toMap function
  Map<String, dynamic> toMap() {
    return {
      'serviceTypeId': serviceTypeId,
      'longitude': longitude,
      'latitude': latitude,
      if (buffer != null) 'buffer': buffer,
    };
  }
}
