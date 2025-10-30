/*import 'package:balady_plus/app/core/shared_local_services/enums.dart';
import 'package:balady_plus/app/core/shared_local_services/navigation_service.dart';
import 'package:balady_plus/app/core/shared_local_services/routes_names.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:balady_plus/shared/core/errors/errors_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'promoted_category_event.dart';
part 'promoted_category_state.dart';

class PromotedCategoryBloc
    extends Bloc<PromotedCategoryEvent, PromotedCategoryState> {
  final GetCategories _getCategories;

  PromotedCategoryBloc({required GetCategories getCategories})
      : _getCategories = getCategories,
        super(PromotedCategoryState()) {
    on<GetPromotedCategories>(_getPromotedCategoriesHandler);
    add(GetPromotedCategories());
  }

  Future<void> _getPromotedCategoriesHandler(
      GetPromotedCategories e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getCategories(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        categories: success.data?.result,
        errorMessage: "",
      ));
    });
  }

  void navigateToCamera(int index) {
    NavigationService.navigatorKey.currentState!.pushNamed(
        RoutesNames.VDCameraPage,
        arguments: CameraParamsPage(
            selectedCategory: state.categories?.items?[index]));
  }
}
*/
