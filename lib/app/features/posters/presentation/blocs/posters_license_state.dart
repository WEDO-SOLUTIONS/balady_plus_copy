part of 'posters_license_bloc.dart';

class PostersLicenseState extends Equatable {
  final BlocStatus status;
  final BlocStatus detailsStatus;
  final int currentPageValue;
  final List<Widget> pagesList;
  final int? requestId;
  final String? error;

  final bool? isDraft;
  final List<PermitsLicensesItem>? permitsLiceses;
  final List<PermitsLicensesItem>? selectedLicenses;
  final String? startDate;
  final String? duration;

  const PostersLicenseState({
    this.status = BlocStatus.initial,
    this.detailsStatus = BlocStatus.initial,
    this.currentPageValue = 0,
    this.requestId,
    this.isDraft,
    this.error,
    this.permitsLiceses,
    this.selectedLicenses,
    this.startDate,
    this.duration,
    this.pagesList = const [
      PostersStep1Page(),
      PostersStep2Page(),
      PostersStep3Page(),
    ],
  });

  @override
  List<Object?> get props => [
        status,
        detailsStatus,
        currentPageValue,
        pagesList,
        requestId,
        isDraft,
        error,
        permitsLiceses,
        selectedLicenses,
        startDate,
        duration
      ];

  PostersLicenseState copyWith(
      {BlocStatus? status,
      BlocStatus? detailsStatus,
      int? currentPageValue,
      List<Widget>? pagesList,
      Nullable<int?>? requestId,
      String? selectedPeriod,
      bool? isDraft,
      List<PermitsLicensesItem>? permitsLiceses,
      List<PermitsLicensesItem>? selectedLicenses,
      String? error,
      String? startDate,
      String? duration}) {
    return PostersLicenseState(
        status: status ?? this.status,
        detailsStatus: detailsStatus ?? this.detailsStatus,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        pagesList: pagesList ?? this.pagesList,
        requestId: requestId == null ? this.requestId : requestId.value,
        isDraft: isDraft ?? this.isDraft,
        permitsLiceses: permitsLiceses ?? this.permitsLiceses,
        selectedLicenses: selectedLicenses ?? this.selectedLicenses,
        error: error ?? this.error,
        startDate: startDate ?? this.startDate,
        duration: duration ?? this.duration);
  }

  String getPosterDataDesc() =>
      "يمكنك اصدار تصاريح للملصقات على واجهة المحل او واجهة الزجاج الخارجي للمحل، اما الملصقات داخل المحل فلا تحتاج الى اصدار تصريح.";
}
