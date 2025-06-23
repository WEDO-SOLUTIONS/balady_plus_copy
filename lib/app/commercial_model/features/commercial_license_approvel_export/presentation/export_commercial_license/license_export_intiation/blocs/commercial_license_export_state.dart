part of 'commercial_license_export_bloc.dart';

class CommercialLicenseExportState extends Equatable {

  final BlocStatus detailsStatus;
  final int? requestId;


  const CommercialLicenseExportState({

    this.detailsStatus = BlocStatus.initial,

    this.requestId,



  });

  @override
  List<Object?> get props => [

        detailsStatus,

        requestId,

      ];

  CommercialLicenseExportState copyWith(
      {
      BlocStatus? detailsStatus,
      Nullable<int?>? requestId,
        String? errorMessage,
       }) {
    return CommercialLicenseExportState(

        detailsStatus: detailsStatus ?? this.detailsStatus,

        requestId: requestId == null ? this.requestId : requestId.value,

    );
  }


}
