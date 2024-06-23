import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../data/model/survey_inquery_data_model.dart';
import '../../domain/use_cases/get_survey_inquery_data.dart';

part 'survey_report_inquery_details_state.dart';

class SurveyReportInqueryDetailsCubit
    extends Cubit<SurveyReportInqueryDetailsState> {
  final GetSurveyInqueryData getLicenseQueryData;
  final int commercialLicenseNumber;

  //final String type;
  final String date;

  SurveyReportInqueryDetailsCubit(
      this.getLicenseQueryData,
      this.commercialLicenseNumber,
      // this.type,
      this.date)
      : super(const SurveyReportInqueryDetailsState()) {
    getLicenseQueryDetails(commercialLicenseNumber, date);
  }

  Future<void> getLicenseQueryDetails(
      int commercialLicenseNumber, String date) async {
    emit(
      state.copyWith(status: BlocRequestStatus.submissionGetLoading),
    );
    final failureOrSuccess =
        await getLicenseQueryData((commercialLicenseNumber, date));
    failureOrSuccess.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage:
                failure is ServerFailure ? (failure).errorMessage : "",
          ),
        );
      },
      (commercialLicenceDetails) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetSuccess,
            commercialLicenceDetails:
                (commercialLicenceDetails.data!.result) as SurveyDataModel,
          ),
        );
      },
    );
  }
}
