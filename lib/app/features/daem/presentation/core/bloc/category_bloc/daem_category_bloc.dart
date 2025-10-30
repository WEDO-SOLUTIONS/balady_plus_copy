import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:tuple/tuple.dart';

import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../data/models/daem_area_type_response.dart';
import '../../../../data/models/daem_category_type_response.dart';
import '../../../../data/models/daem_issue_type_response.dart';
import '../../../../data/models/daem_item.dart';
import '../../../../data/models/daem_municipality_response.dart';
import '../../../../data/models/daem_sub_category_type_response.dart';
import '../../../../data/models/new_ticket_page_args.dart';
import '../../services/daem_repository.dart';
part 'daem_category_event.dart';
part 'daem_category_state.dart';

class DaemCategoryBloc extends Bloc<DaemCategoryEvent, DaemCategoryState> {
  final DaemRepository _repository = DaemRepository();
  List<DaemItem>? categories;
  DaemCategoryBloc({this.categories})
      : super(DaemCategoryState(
            status: BlocStatus.initial, categoryTypeList: categories)) {
    // on<DaemCategoryEvent>((event, emit) {});

    on<GetDaemCategoryEvent>(_getDaemCategoriesHandler);
    on<GetDaemSubCategoryEvent>(_getDaemSubCategoriesHandler);
    on<GetDaemMunicipalityEvent>(_getDaemMunicipalityHandler);

    on<GetDaemMunicipalitiesAndSubCategoryEvent>(
        _getDaemMunicipalityAndSubCategoriesHandler);
    on<GetDaemAreasEvent>(_getDaemAreaListHandler);
    on<GetDaemIssuesEvent>(_getDaemIssueListHandler);

    add(GetDaemCategoryEvent());
  }

  Future<void> _getDaemCategoriesHandler(
      GetDaemCategoryEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    Tuple3<bool?, String?, DaemCategoryTypeResponse?> response =
        await _repository.getDaemCategoryList();
    emitter(state.copyWith(status: BlocStatus.loaded));
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.categoryTypeList != null &&
        response.item3!.categoryTypeList!.isNotEmpty) {
      emitter(state.copyWith(
          status: BlocStatus.success,
          categoryTypeList: response.item3?.getList()));
    } else {
      emitter(state.copyWith(
          status: BlocStatus.retry,
          categoryTypeList: [],
          error: response.item2 ?? ("errors_server_error_1").tr()));
    }
  }

  Future<void> _getDaemSubCategoriesHandler(
      GetDaemSubCategoryEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    Tuple3<bool?, String?, DaemSubCategoryTypeResponse?> response =
        await _repository.getDaemSubCategoryList(e.category.id!);
    emitter(state.copyWith(status: BlocStatus.loaded));
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.categoryTypeList != null &&
        response.item3!.categoryTypeList!.isNotEmpty) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        subCategoryTypeList: response.item3?.getList(),
      ));
    } else {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          // categoryTypeList: [],
          error: response.item2 ?? ("errors_server_error_1").tr()));
    }
  }

  Future<void> _getDaemMunicipalityHandler(
      GetDaemMunicipalityEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    Tuple3<bool?, String?, DaemMunicipalityResponse?> response =
        await _repository.getAmanat();
    emitter(state.copyWith(status: BlocStatus.loaded));
    List<DaemItem>? amanat = response.item3?.getList();
    if (response.item1 != null &&
        response.item1! &&
        amanat != null &&
        amanat.isNotEmpty) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        municipalities: amanat,
      ));
    } else {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          // categoryTypeList: [],
          error: response.item2 ?? ("errors_server_error_1").tr()));
    }
  }

  Future<void> _getDaemMunicipalityAndSubCategoriesHandler(
      GetDaemMunicipalitiesAndSubCategoryEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;

    emitter(state.copyWith(status: BlocStatus.loading));

    List<dynamic> results = await Future.wait([
      _repository.getAmanat(),
      _repository.getDaemSubCategoryList(e.category.id!)
    ]);

    Tuple3<bool?, String?, DaemMunicipalityResponse?> response1 = results[0];
    Tuple3<bool?, String?, DaemSubCategoryTypeResponse?> response2 = results[1];

    emitter(state.copyWith(status: BlocStatus.loaded));

    List<DaemItem>? amanat = response1.item3?.getList();

    List<SubCategoryTypeList>? subcategoryTypeList =
        response2.item3?.categoryTypeList;
    if ((response1.item1 != null &&
            response1.item1! &&
            amanat != null &&
            amanat.isNotEmpty) &&
        (response2.item1 != null &&
            response2.item1! &&
            subcategoryTypeList != null &&
            subcategoryTypeList.isNotEmpty)) {
      emitter(state.copyWith(
          status: BlocStatus.success,
          municipalities: amanat,
          category: e.category,
          subCategoryTypeList: response2.item3?.getList()));
      if (subcategoryTypeList.length == 1) {
        add(GetDaemAreasEvent(
            category: e.category,
            subCategory: response2.item3!.getList()!.first));
      } else {
        NavigationService.navigatorKey.currentState!.pushNamed(
            RouteName.newDaemTicket,
            arguments: NewTicketPageArgs(
                category: state.category!,
                subCategoryTypeList: state.subCategoryTypeList!,
                municipalities: state.municipalities!));
      }
    } else {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: response2.item2 ?? ("errors_server_error_1").tr()));
    }
  }

  Future<void> _getDaemAreaListHandler(
      GetDaemAreasEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    Tuple3<bool?, String?, DaemAreaTypeResponse?> response =
        await _repository.getDaemAreaList(
            category: e.category.id!, subCategory: e.subCategory.id!);
    emitter(state.copyWith(
      status: BlocStatus.loaded,
    ));
    List<DaemItem>? areaList = response.item3!.getList();
    if (response.item1 != null &&
        response.item1! &&
        areaList != null &&
        areaList.isNotEmpty) {
      emitter(state.copyWith(
          status: BlocStatus.success,
          areaList: areaList,
          subCategory: e.subCategory));

      if (areaList.length == 1) {
        add(GetDaemIssuesEvent(
            category: state.category!,
            area: state.areaList!.first,
            subCategory: state.subCategory!));
      } else {
        NavigationService.navigatorKey.currentState!.pushNamed(
            RouteName.newDaemTicket,
            arguments: NewTicketPageArgs(
                category: state.category!,
                subCategory: state.subCategoryTypeList?.first,
                areaList: state.areaList,
                subCategoryTypeList: state.subCategoryTypeList!,
                municipalities: state.municipalities!));
      }
    } else {
      NavigationService.navigatorKey.currentState!.pushNamed(
          RouteName.newDaemTicket,
          arguments: NewTicketPageArgs(
              category: state.category!,
              subCategoryTypeList: state.subCategoryTypeList!,
              municipalities: state.municipalities!));
    }
  }

  Future<void> _getDaemIssueListHandler(
      GetDaemIssuesEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    Tuple3<bool?, String?, DaemIssueTypeResponse?> response =
        await _repository.getDaemIssueTypeList(
            category: e.category.id!,
            subCategory: e.subCategory.id!,
            area: e.area.id!);
    emitter(state.copyWith(
      status: BlocStatus.loaded,
    ));
    List<DaemItem>? issues = response.item3!.getList();
    if (response.item1 != null &&
        response.item1! &&
        issues != null &&
        issues.isNotEmpty) {
      emitter(state.copyWith(
          status: BlocStatus.success, area: e.area, issuesList: issues));

      if (issues.length == 1) {
        NavigationService.navigatorKey.currentState!.pushNamed(
            RouteName.newDaemTicket,
            arguments: NewTicketPageArgs(
                category: state.category!,
                subCategory: state.subCategoryTypeList?.first,
                areaList: state.areaList,
                area: state.area,
                issueType: state.issuesList?.first,
                issuesList: state.issuesList,
                subCategoryTypeList: state.subCategoryTypeList!,
                municipalities: state.municipalities!));
      } else {
        NavigationService.navigatorKey.currentState!.pushNamed(
            RouteName.newDaemTicket,
            arguments: NewTicketPageArgs(
                category: state.category!,
                subCategory: state.subCategoryTypeList?.first,
                areaList: state.areaList,
                area: state.area,
                issuesList: state.issuesList,
                subCategoryTypeList: state.subCategoryTypeList!,
                municipalities: state.municipalities!));
      }
    } else {
      NavigationService.navigatorKey.currentState!.pushNamed(
          RouteName.newDaemTicket,
          arguments: NewTicketPageArgs(
              category: state.category!,
              subCategory: state.subCategoryTypeList?.first,
              area: state.area,
              areaList: state.areaList,
              subCategoryTypeList: state.subCategoryTypeList!,
              municipalities: state.municipalities!));
    }
  }
}
