part of 'msr_bloc.dart';

class MSRState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;

  MSRState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    this.currentPageValue = 0,
  });

  bool isNextButtonEnabled() {
    if (currentPageValue == 0) {}

    return false;
  }

  MSRState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      int? currentPageValue,
      int? selectedSPLIndex,
      String? issueDesc,
      bool? clearSPLDetailsResponse,
      bool? clearSPLResponse,
      String? firstName,
      String? lastName,
      String? mobileNumber,
      bool? agreement,
      bool? isFromHome,
      bool? isSearchShown,
      String? splSearchedText,
      bool? isCrValid,
      String? crNumber}) {
    return MSRState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPageValue: currentPageValue ?? this.currentPageValue,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentPageValue,
      ];
}
