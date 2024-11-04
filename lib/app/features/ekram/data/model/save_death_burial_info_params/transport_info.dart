class TransportInfo {
  bool? needSpecialTransport;
  int? charityId;
  int? mosqueId;
  int? ghuslPlaceId;

  TransportInfo({
    this.needSpecialTransport,
    this.charityId,
    this.mosqueId,
    this.ghuslPlaceId,
  });

  Map<String, dynamic> toJson() => {
        'needSpecialTransport': needSpecialTransport,
        'charityId': charityId,
        'mosqueId': mosqueId,
        'ghuslPlaceId': ghuslPlaceId,
      };
}
