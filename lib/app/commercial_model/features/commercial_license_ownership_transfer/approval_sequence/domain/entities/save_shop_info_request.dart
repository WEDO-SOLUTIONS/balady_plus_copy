class SaveShopInfoRequest {
  String? shopName;
  bool? hasBrand;

  SaveShopInfoRequest({this.shopName, this.hasBrand});

  factory SaveShopInfoRequest.fromJson(Map<String, dynamic> json) {
    return SaveShopInfoRequest(
      shopName: json['shopName'] as String?,
      hasBrand: json['hasBrand'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'shopName': shopName,
        'hasBrand': hasBrand,
      };
}
