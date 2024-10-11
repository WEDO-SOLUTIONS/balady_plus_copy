import 'dart:io';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/classification_certificate/data/model/details/details_request_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../../../domain/use_cases/classification_certificate_use_cases.dart';
import 'classification_certificate_details_state.dart';

class ClassificationCertificateDetailsCubit
    extends Cubit<ClassificationCertificateDetailsState> {
  final GetDetailsClassificationCertificateUseCases getDetailsUseCases;
  final GetAttachedClassificationCertificateUseCases getAttachedUseCases;

  final DetailsRequestModel detailsRequestModel;

  ////////////////////////////////////////////////////////////////////////////
  ClassificationCertificateDetailsCubit({
    required this.detailsRequestModel,
  })  : getDetailsUseCases = sl<GetDetailsClassificationCertificateUseCases>(),
        getAttachedUseCases =
            sl<GetAttachedClassificationCertificateUseCases>(),
        super(const ClassificationCertificateDetailsState()) {
    getDetailsClassificationCertificate(
      detailsRequestModel: detailsRequestModel,
    );
  }

  void getDetailsClassificationCertificate(
      {required DetailsRequestModel detailsRequestModel}) async {
    try {
      emit(const LoadingDetailsClassificationCertificateState());
      var response = await getDetailsUseCases(detailsRequestModel);
      response.fold(
        (filer) {
          emit(
            FieldDetailsClassificationCertificateState(
              errorMessage: filer.toString(),
            ),
          );
        },
        (data) {
          DateTime? end =
              DateTime.tryParse(data.certificateExpiryDate.substring(0, 8));
          DateTime? start =
              DateTime.tryParse(data.certificateStartDate.substring(0, 8));
          String? certificateExpiryDate = '', certificateStartDate = '';
          if (end != null) {
            certificateExpiryDate = DateFormat(
              "locale".tr() == "ar" ? 'yyyy/MM/dd' : 'dd/MM/yyyy',
              'locale'.tr(),
            ).format(end);
          }
          if (start != null) {
            certificateStartDate = DateFormat(
              "locale".tr() == "ar" ? 'yyyy/MM/dd' : 'dd/MM/yyyy',
              'locale'.tr(),
            ).format(start);
          }
          emit(
            SuccessDetailsClassificationCertificateState(
              classificationCertificateDetails: data,
              formatCertificateExpiryDate: certificateExpiryDate,
              formatCertificateStartDate: certificateStartDate,
            ),
          );
        },
      );
    } on ServerException catch (error) {
      emit(
        FieldDetailsClassificationCertificateState(
          errorMessage: error.errorMessage,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        FieldDetailsClassificationCertificateState(
          errorMessage: error.toString(),
        ),
      );
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  ///////////////////////////////////////////////////////////////////////////
  void getAttachedFile({
    required String attachUrl,
    required String nameFile,
  }) async {
    ClassificationCertificateDetailsState typeState = state;
    try {
      if (typeState is SuccessDetailsClassificationCertificateState) {
        emit(
          LoadingAttachedCertificateState(
            classificationCertificateDetails:
                typeState.classificationCertificateDetails,
            formatCertificateExpiryDate: typeState.formatCertificateExpiryDate,
            formatCertificateStartDate: typeState.formatCertificateStartDate,
          ),
        );
        //////////////////////////////////////////////////////////////////
        var response = await getAttachedUseCases((attachUrl, "$nameFile.pdf"));
        response.fold(
          (filer) {
            emit(typeState);
            CommonFunctions.showError(filer.toString());
          },
          (data) {
            // Open file after dwonload
            OpenFile.open(data.path);
            emit(
              SuccessAttachedCertificateState(
                file: data,
                classificationCertificateDetails:
                    typeState.classificationCertificateDetails,
                formatCertificateExpiryDate:
                    typeState.formatCertificateExpiryDate,
                formatCertificateStartDate:
                    typeState.formatCertificateStartDate,
              ),
            );
          },
        );
        //////////////////////////////////////////////////////////////////
      }
    } on ServerException catch (error) {
      emit(typeState);
      CommonFunctions.showError(error.errorMessage);
    } catch (error, stackTrace) {
      emit(typeState);
      CommonFunctions.showError(error.toString());
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }
}
