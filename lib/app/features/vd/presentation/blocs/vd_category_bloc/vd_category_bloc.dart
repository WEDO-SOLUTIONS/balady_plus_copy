import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../../core/utils/enums/bloc_status.dart';

part 'vd_category_event.dart';

part 'vd_category_state.dart';

class VDCategoryBloc extends Bloc<VDCategoryEvent, VDCategoryState> {
  final GetCategories _getCategories;

  VDCategoryBloc({
    required GetCategories getCategories,
    bool isPromoted = false,
    bool isVD = false,
  })  : _getCategories = getCategories,
        super(VDCategoryState()) {
    on<GetVDCategories>(_getVDCategoriesHandler);
    on<GetAllCategories>(_getAllCategoriesHandler);
    on<GetPromotedCategories>(_getPromotedCategoriesHandler);

    on<RefreshCategoriesEvent>(_refreshCategoriesHandler);

    add(GetAllCategories());
    add(GetPromotedCategories());
    add(GetVDCategories());
  }

  Future<void> _refreshCategoriesHandler(
      RefreshCategoriesEvent e, Emitter emitter) async {
    //  if (state.allCategorystatus == BlocStatus.failure)
    add(GetAllCategories());
    //  if (state.promotedCategorystatus == BlocStatus.failure)
    add(GetPromotedCategories());
    //  if (state.vdCategorystatus == BlocStatus.failure)
    add(GetVDCategories());
  }

  Future<void> _getAllCategoriesHandler(
      GetAllCategories e, Emitter emitter) async {
    emitter(state.copyWith(allCategorystatus: BlocStatus.loading));

    final failureOrSuccess = await _getCategories(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        allCategorystatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        allCategorystatus: BlocStatus.success,
        //  categories: success.data?.result,
        allCategories: success.items,
        qrCategory: (success.items ?? [])
            .where((element) =>
                RemoteConfig.marketClass.contains(element.categoryId))
            .toList(),
        errorMessage: "",
      ));
    });
  }

  Future<void> _getVDCategoriesHandler(
      GetVDCategories e, Emitter emitter) async {
    emitter(state.copyWith(vdCategorystatus: BlocStatus.loading));

    final failureOrSuccess = await _getCategories(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        vdCategorystatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        vdCategorystatus: BlocStatus.success,
        //   categories: success.data?.result,
        vdCategories: success.items,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getPromotedCategoriesHandler(
      GetPromotedCategories e, Emitter emitter) async {
    emitter(state.copyWith(promotedCategorystatus: BlocStatus.loading));

    final failureOrSuccess = await _getCategories(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        promotedCategorystatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        promotedCategorystatus: BlocStatus.success,
        //  categories: success.data?.result,
        promotedCategories: success.items,
        errorMessage: "",
      ));
    });
  }

  void navigateToCamera(int index,
      {bool isVD = false, bool isPromoted = false,}) {
    CategoryItem? selectedCategory;

    if (isVD)
      selectedCategory = state.vdCategories?[index];
    else if (isPromoted)
      selectedCategory = state.promotedCategories?[index];
    else
      selectedCategory = state.allCategories?[index];
    NavigationService.navigatorKey.currentState!.pushNamed(
      RouteName.vdCameraPage,
      arguments: CameraParamsPage(
        selectedCategory: selectedCategory,
        // isFromHome: isVD || isFromHome,
      ),
    );
  }
}
