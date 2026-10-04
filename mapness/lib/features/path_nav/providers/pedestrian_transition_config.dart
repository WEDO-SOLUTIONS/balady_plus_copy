import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/path_nav/models/pedestrian_transition_config.dart';

/// Static defaults for now; override here once the values come from remote config.
final pedestrianTransitionConfigProvider = Provider<PedestrianTransitionConfig>(
  (ref) => PedestrianTransitionConfig.defaults,
);
