import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import 'package:equatable/equatable.dart';

class RubricsState extends Equatable {
  final BlocStatus rubricsStatus;
  final List<LookUpItem>? rubrics;
  final String? errorMessage;

  const RubricsState({
    this.rubricsStatus = BlocStatus.initial,
    this.rubrics,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        rubricsStatus,
        rubrics,
        errorMessage,
      ];

  RubricsState copyWith({
    BlocStatus? rubricsStatus,
    List<LookUpItem>? rubrics,
    String? errorMessage,
  }) {
    return RubricsState(
      rubricsStatus: rubricsStatus ?? this.rubricsStatus,
      rubrics: rubrics ?? this.rubrics,
      errorMessage: errorMessage,
    );
  }
}
