import 'package:flutter/foundation.dart';

sealed class FeedbackBaseRouteParams {
  const FeedbackBaseRouteParams();
}

class FeedbackNoParams extends FeedbackBaseRouteParams {
  const FeedbackNoParams();
}

@immutable
class FeedbackObjectIdParams extends FeedbackBaseRouteParams {
  final int objectId;

  const FeedbackObjectIdParams(this.objectId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedbackObjectIdParams && runtimeType == other.runtimeType && objectId == other.objectId;

  @override
  int get hashCode => objectId.hashCode;
}
