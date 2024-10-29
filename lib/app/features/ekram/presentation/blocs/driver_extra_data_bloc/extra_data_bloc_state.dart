part of 'extra_data_bloc.dart';

class ExtraDataState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final Map<int, List<GhuslEmploye>>? lstEmployee;
  final Map<int, GhuslEmploye>? lstSelectedEmploye;
  final Map<int, List<DeceasedAttachment>>? lstDeceasedAttachment;

  ExtraDataState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
       this.lstEmployee,
        this.lstDeceasedAttachment,
        this.lstSelectedEmploye,
     });

  ExtraDataState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
        final List<DeceasedIdenticalItem>? lstDeceasedIdenticalItem,
      final  Map<int, List<GhuslEmploye>>? lstEmploye,
        final  Map<int, List<DeceasedAttachment>>? lstDeceasedAttachment,
       final Map<int, GhuslEmploye>? lstSelectedEmployee,
      final bool? isCompleted}) {
    return ExtraDataState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        lstEmployee: lstEmploye ?? this.lstEmployee,
      lstDeceasedAttachment: lstDeceasedAttachment ?? this.lstDeceasedAttachment,
        lstSelectedEmploye: lstSelectedEmployee ?? this.lstSelectedEmploye,
        );
  }

  @override
  List<Object?> get props => [status, lstEmployee,lstSelectedEmploye,lstDeceasedAttachment, errorMessage];
}
