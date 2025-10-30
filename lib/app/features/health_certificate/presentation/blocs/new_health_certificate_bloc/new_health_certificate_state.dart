part of 'new_health_certificate_bloc.dart';

class NewHealthCertificateState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;
  final bool? renew;
  NewHealthCertificateState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.currentPageValue = 0,
      this.renew});

  bool isNextButtonEnabled() {
    if (currentPageValue == 0) {}

    return false;
  }

  NewHealthCertificateState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      int? currentPageValue,
      bool? renew}) {
    return NewHealthCertificateState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        renew: renew ?? this.renew);
  }

  @override
  List<Object?> get props => [status, currentPageValue, renew, errorMessage];
}
