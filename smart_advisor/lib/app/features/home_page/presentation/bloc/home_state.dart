import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/_shared_feature_/presentation/models/grideViewModel.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final BlocStatus sectorStatus;
  final List<LookUpItem>? sectors;
  final String? errorMessage;
  final bool? showChatHint;
  const HomeState({
    this.sectors,
    this.showChatHint = true,
    this.sectorStatus = BlocStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props =>
      [showChatHint, sectors, errorMessage, sectorStatus];

  HomeState copyWith({
    List<GrideViewModel>? entityTypesList,
    bool? showChatHint,
    final BlocStatus? sectorStatus,
    final List<LookUpItem>? sectors,
    final String? errorMessage,
  }) {
    return HomeState(
      showChatHint: showChatHint ?? this.showChatHint,
      sectorStatus: sectorStatus ?? this.sectorStatus,
      sectors: sectors ?? this.sectors,
      errorMessage: errorMessage,
    );
  }
}
