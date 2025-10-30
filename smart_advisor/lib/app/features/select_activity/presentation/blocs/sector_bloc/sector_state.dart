part of 'sector_bloc.dart';

class SectorState extends Equatable {
  final BlocStatus sectorStatus;
  final List<LookUpItem>? sectors;
  final String? errorMessage;

  const SectorState({
    this.sectorStatus = BlocStatus.initial,
    this.sectors,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        sectorStatus,
        sectors,
        errorMessage,
      ];

  SectorState copyWith({
    BlocStatus? sectorStatus,
    List<LookUpItem>? sectors,
    String? errorMessage,
  }) {
    return SectorState(
      sectorStatus: sectorStatus ?? this.sectorStatus,
      sectors: sectors ?? this.sectors,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() {
    return 'AddetionalActivityState(sectors: $LookUpItem, SectorStatus: $sectorStatus, errorMessage: $errorMessage)';
  }
}
