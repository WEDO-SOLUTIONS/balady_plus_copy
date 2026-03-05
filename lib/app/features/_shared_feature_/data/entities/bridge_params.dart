import 'package:equatable/equatable.dart' show Equatable;

import '../../../../core/utils/utils_exports.dart' show BridgeFlow;

/// BridgeParams: Bridge Parameters
class BridgeParams extends Equatable {
  final BridgeFlow? flow;
  final bool isAuthenticated;
  final bool clearAuth;

  /// BridgeParams: System Bridge Parameters
  const BridgeParams({this.flow, this.isAuthenticated = true, this.clearAuth = false});

  BridgeFlow get flowType => flow ?? (isAuthenticated ? BridgeFlow.home : BridgeFlow.signIn);

  @override
  List<Object?> get props => [flow, clearAuth];

  BridgeParams copyWith({BridgeFlow? flow, bool? isAuthenticated, bool? clearAuth}) {
    return BridgeParams(
      flow: flow ?? this.flow,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      clearAuth: clearAuth ?? this.clearAuth,
    );
  }

  @override
  String toString() => 'BridgeParams(flow: $flow, isAuthenticated: $isAuthenticated, clearAuth: $clearAuth)';
}
