import 'package:dgis_map/library.dart';

/// Represents the type of object for which feedback can be provided.
/// This types are supported by backend and the "зацепки" (discrepancy) service
enum FeedbackObjectType {
  building,
  branch,
  street;

  /// Creates a [FeedbackObjectType] from an [ObjectTypeMessage].
  ///
  /// This factory method maps [ObjectTypeMessage] values to corresponding
  /// [FeedbackObjectType] values. If the input doesn't match any specific type,
  /// it defaults to [FeedbackObjectType.building].
  ///
  /// @param message The [ObjectTypeMessage] to convert.
  /// @return The corresponding [FeedbackObjectType].
  factory FeedbackObjectType.fromMessage(ObjectTypeMessage? message) => switch (message) {
        ObjectTypeMessage.branch => FeedbackObjectType.branch,
        ObjectTypeMessage.admDivDistrict || ObjectTypeMessage.street => FeedbackObjectType.street,
        ObjectTypeMessage.building => FeedbackObjectType.building,

        // Handles all other cases
        _ => FeedbackObjectType.building,
      };
}
