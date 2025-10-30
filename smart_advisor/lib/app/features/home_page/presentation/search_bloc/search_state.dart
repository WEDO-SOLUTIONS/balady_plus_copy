import '../../data/models/search_isic_model.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/_shared_feature_/presentation/models/grideViewModel.dart';
import 'package:equatable/equatable.dart';

class SearchState extends Equatable {
  final BlocStatus sectorStatus;
  final List<SearchIsicModel>? sectors;
  final String? errorMessage;
  final bool? showChatHint;
  const SearchState({
    this.sectors,
    this.showChatHint = true,
    this.sectorStatus = BlocStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props =>
      [showChatHint, sectors, errorMessage, sectorStatus];

  SearchState copyWith({
    List<GrideViewModel>? entityTypesList,
    bool? showChatHint,
    final BlocStatus? sectorStatus,
    final List<SearchIsicModel>? sectors,
    final String? errorMessage,
  }) {
    return SearchState(
      showChatHint: showChatHint ?? this.showChatHint,
      sectorStatus: sectorStatus ?? this.sectorStatus,
      sectors: sectors ?? this.sectors,
      errorMessage: errorMessage,
    );
  }
}
