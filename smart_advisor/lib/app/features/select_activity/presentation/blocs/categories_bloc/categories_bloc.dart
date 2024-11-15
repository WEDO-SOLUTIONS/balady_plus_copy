import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/select_activity/domain/entities/categories_page_params.dart';
import '/app/features/select_activity/domain/entities/categories_request_params.dart';
import '/app/features/select_activity/domain/use_cases/get_categories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../../core/errors/errors_exports.dart' show ServerFailure;

import '../../../../../core/utils/utils_exports.dart' show BlocStatus;

part 'categories_event.dart';

part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategoriesUc _getCategories;
  final CategoriesPageParams args;

  CategoriesBloc({required this.args})
      : _getCategories = GetCategoriesUc(repository: sl()),
        super(const CategoriesState()) {
    ///
    on<GetCategoriesEvent>((event, emit) async {
      emit(state.copyWith(categoriesStatus: BlocStatus.loading));

      final failureOrSuccess = await _getCategories(CategoriesRequestParams(
        sectorID: args.sector.id,
      ));
      await failureOrSuccess.fold(
        (failure) async {
          print(failure);
          emit(state.copyWith(categoriesStatus: BlocStatus.closeLoading));
          emit(state.copyWith(
            categoriesStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (success) async {
          print(success);
          emit(state.copyWith(
            categoriesStatus: BlocStatus.success,
            categories: success,
          ));
        },
      );
    });

    add(const GetCategoriesEvent());
  }
}
