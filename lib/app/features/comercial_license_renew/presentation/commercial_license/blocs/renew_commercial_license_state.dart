part of 'renew_commercial_license_bloc.dart';

class RenewCommercialLicenseState extends Equatable {
  final BlocStatus status;
  final int currentPageValue;
  final List<Widget> pagesList;
  final int? requestId;

  const RenewCommercialLicenseState({
    this.status = BlocStatus.initial,
    this.currentPageValue = 0,
    this.requestId,
    this.pagesList = const [],
  });

  @override
  List<Object?> get props => [status, currentPageValue, pagesList, requestId];

  RenewCommercialLicenseState copyWith({
    BlocStatus? status,
    int? currentPageValue,
    List<Widget>? pagesList,
    int? requestId,
  }) {
    return RenewCommercialLicenseState(
      status: status ?? this.status,
      currentPageValue: currentPageValue ?? this.currentPageValue,
      pagesList: pagesList ?? this.pagesList,
      requestId: requestId ?? this.requestId,
    );
  }
}
