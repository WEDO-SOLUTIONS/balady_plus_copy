import 'package:equatable/equatable.dart' show Equatable;

class DeviceDetails extends Equatable {
  final String deviceOs;
  final String deviceId;
  final String deviceName;

  const DeviceDetails({
    this.deviceOs = "",
    this.deviceId = "",
    this.deviceName = "",
  });

  @override
  List<Object?> get props => [deviceOs, deviceId, deviceName];

  DeviceDetails copyWith({
    String? deviceOs,
    String? deviceId,
    String? deviceName,
  }) {
    return DeviceDetails(
      deviceOs: deviceOs ?? this.deviceOs,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
    );
  }

  @override
  String toString() =>
      'DeviceDetails(deviceOs: $deviceOs, deviceId: $deviceId, deviceName: $deviceName)';
}
