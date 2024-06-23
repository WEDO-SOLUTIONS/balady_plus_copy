class SetNotificationsProfileParams {
  bool? enabled;
  String? channelId;
  String? applicationId;

  SetNotificationsProfileParams({
    this.enabled,
    this.channelId,
    this.applicationId,
  });

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'channelId': channelId,
        'applicationId': applicationId,
      };

  SetNotificationsProfileParams copyWith({
    bool? enabled,
    String? channelId,
    String? applicationId,
  }) {
    return SetNotificationsProfileParams(
      enabled: enabled ?? this.enabled,
      channelId: channelId ?? this.channelId,
      applicationId: applicationId ?? this.applicationId,
    );
  }
}
