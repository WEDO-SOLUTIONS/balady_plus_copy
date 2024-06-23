class SetNotificationsProfileProductsParams {
  bool? enabled;
  String? channelId;
  String? applicationId;
  String? productId;

  SetNotificationsProfileProductsParams({
    this.enabled,
    this.channelId,
    this.applicationId,
    this.productId,
  });

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'channelId': channelId,
        'applicationId': applicationId,
        'productId': productId,
      };

  SetNotificationsProfileProductsParams copyWith({
    String? id,
    bool? enabled,
    String? channelId,
    String? applicationId,
    String? productId,
  }) {
    return SetNotificationsProfileProductsParams(
      enabled: enabled ?? this.enabled,
      channelId: channelId ?? this.channelId,
      applicationId: applicationId ?? this.applicationId,
      productId: productId ?? this.productId,
    );
  }
}
