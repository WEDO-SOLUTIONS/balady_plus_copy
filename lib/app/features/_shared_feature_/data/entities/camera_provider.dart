import 'package:camera/camera.dart' show CameraDescription;
import 'package:equatable/equatable.dart' show Equatable;

class CamerasProvider extends Equatable {
  final List<CameraDescription> cameras;
  const CamerasProvider(this.cameras);

  @override
  List<Object?> get props => [cameras];
}
