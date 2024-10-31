import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import 'package:equatable/equatable.dart';

class IsicsState extends Equatable {
  final BlocStatus isicsStatus;
  final List<LookUpItem>? isics;
  final String? errorMessage;

  const IsicsState({
    this.isicsStatus = BlocStatus.initial,
    this.isics,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        isicsStatus,
        isics,
        errorMessage,
      ];

  IsicsState copyWith({
    BlocStatus? isicsStatus,
    List<LookUpItem>? isics,
    String? errorMessage,
  }) {
    return IsicsState(
      isicsStatus: isicsStatus ?? this.isicsStatus,
      isics: isics ?? this.isics,
      errorMessage: errorMessage,
    );
  }
}
