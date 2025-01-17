import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/classification_certificate/data/model/search_request/search_request_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/classification_certificate_list_entity.dart';
import '../../../domain/use_cases/classification_certificate_use_cases.dart';
import 'classification_certificate_list_state.dart';

class ClassificationCertificateListCubit
    extends Cubit<ClassificationCertificateListState> {
  final SearchClassificationCertificateUseCases searchUseCases;

  final SearchRequestModel searchRequestModel;

  ////////////////////////////////////////////////////////////////////////////
  ClassificationCertificateListCubit({
    required this.searchRequestModel,
  })  : searchUseCases = sl<SearchClassificationCertificateUseCases>(),
        super(const ClassificationCertificateListState()) {
    searchClassificationCertificate(
      searchRequestModel: searchRequestModel,
    );
  }

  void searchClassificationCertificate(
      {required SearchRequestModel searchRequestModel}) async {
    try {
      ClassificationCertificateListState stateType = state;
      if (stateType
          is! SucceedWithPaginationListClassificationCertificateState) {
        emit(const LoadingListClassificationCertificateState());
      }

      var response = await searchUseCases(searchRequestModel);
      response.fold(
        (filer) {
          if(filer is NoDataFoundFailure) {
            emit(const NoListClassificationCertificateDebtState());
          } else {
            emit(
              FieldListClassificationCertificateState(
                errorMessage: filer.toString(),
                searchRequestModel: searchRequestModel,
              ),
            );
          }
        },
        (data) {
          List<ClassificationCertificateItemEntity> type = [];
          if (stateType
              is SucceedWithPaginationListClassificationCertificateState) {
            type = stateType.classificationCertificateItem;
          }
          type += data.classificationCertificateItem;
          if (data.totalPageCount == searchRequestModel.pageNumber) {
            if (type.isEmpty) {
              emit(const NoListClassificationCertificateDebtState());
            } else {
              emit(
                SuccessListClassificationCertificateState(
                  classificationCertificateItem: type,
                ),
              );
            }
          } else {
            emit(
              SucceedWithPaginationListClassificationCertificateState(
                searchRequestModel: searchRequestModel.copyWith(
                  pageNumber: searchRequestModel.pageNumber + 1,
                ),
                classificationCertificateItem: type,
              ),
            );
          }
        },
      );
    } on ServerException catch (error) {
      emit(
        FieldListClassificationCertificateState(
          errorMessage: error.errorMessage,
          searchRequestModel: searchRequestModel,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        FieldListClassificationCertificateState(
          errorMessage: error.toString(),
          searchRequestModel: searchRequestModel,
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
}
