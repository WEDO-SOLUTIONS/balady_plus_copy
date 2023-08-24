import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';

class ViolationState extends Equatable {
  final BlocStatus status;
  final int selectedIndex;

  const ViolationState({
    this.status = BlocStatus.initial,
    required this.selectedIndex,
  });

  ViolationState copyWith(
      {final BlocStatus? status, final int? selectedIndex}) {
    return ViolationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        status,
        selectedIndex,
      ];
}
