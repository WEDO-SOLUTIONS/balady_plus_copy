import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import '../../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';

import '../../../../../../features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../data/models/permit_license_response_model.dart';
import '../../blocs/posters_license_bloc.dart';
import 'license_item_widget.dart';

class PermitsLicenseBottomSheetList extends StatefulWidget {
  final int groupId;
  const PermitsLicenseBottomSheetList({super.key, required this.groupId});

  @override
  State<PermitsLicenseBottomSheetList> createState() =>
      _PermitsLicenseBottomSheetListState();
}

class _PermitsLicenseBottomSheetListState
    extends State<PermitsLicenseBottomSheetList> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostersLicenseBloc(groupId: widget.groupId)
        ..add(const GetLicensePermitsEvents()),
      child: BlocListener<PostersLicenseBloc, PostersLicenseState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.error ?? "");
          }
        },
        child: BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
          builder: (context, state) {
            return BottomSheetWithActions(
              title: "posters_licenses_list".tr(),
              isList: true,
              searchable: false,
              backgroundColor: AppColor.scaffoldBackground,
              onSearchChanged: (String? text) {
                /*setState(() {
                      items = (state.permitsLiceses ?? [])
                          .where((element) => element.licenseId
                              .toString()
                              .toLowerCase()
                              .contains(text ?? ""))
                          .toList();
                    });*/
              },
              body: PermitLicensesListWidget(),
            );
          },
        ),
      ),
    );
  }
}

class PermitLicensesListWidget extends StatefulWidget {
  const PermitLicensesListWidget({super.key});

  @override
  State<PermitLicensesListWidget> createState() =>
      _PermitLicensesListWidgetState();
}

class _PermitLicensesListWidgetState extends State<PermitLicensesListWidget> {
  //List<PermitsLicensesItem> items = [];
  List<PermitsLicensesItem> selectedValues = [];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<PostersLicenseBloc>().add(const GetMoreLicensesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostersLicenseBloc, PostersLicenseState>(
        listener: (context, state) {
      // TODO: implement listener
    }, builder: (context, state) {
      return Flexible(
        child: Container(
          child: Stack(
            children: [
              if (state.status == BlocStatus.success &&
                  (state.permitsLiceses?.length ?? 0) <= 0)
                Align(
                  alignment: Alignment.center,
                  child: CustomTextWidget(
                    "posters_no_license".tr(),
                    fontColor: AppColor.blackModern600Light,
                    fontSize: 18,
                    textAlign: TextAlign.center,
                    maxLines: 10,
                    height: 1.4,
                    fontWeight: AppFontWeight.bold,
                  ),
                ),
              /*  if ((state.status == BlocStatus.success &&
                      (state.permitsLiceses?.length ?? 0) > 0) ||
                  (state.status == BlocStatus.loadMore))*/
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: (state.permitsLiceses?.length ?? 0) + 1,
                  controller: _scrollController,
                  itemBuilder: (ctx, index) {
                    if (index >= (state.permitsLiceses?.length ?? 0)) {
                      if (state.status == BlocStatus.loadMore) {
                        return const SizedBox(
                          height: 50,
                          child: Center(child: CustomCircularLoadingWidget()),
                        );
                      } else {
                        return Container(height: 50);
                      }
                    }
                    PermitsLicensesItem item = state.permitsLiceses![index];

                    return InkWell(
                      onTap: () {
                        selectedValues.add(item);
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColor.primary50Light50,
                            ),
                            child: PostersLicenseItemWidget(
                              licenseNo: "${item.licenseId?.toInt()}",
                              status: item.statusName,
                              location:
                                  "${item.municipalityName}, ${item.subMunicipalityName} ",
                              expiryDate: item.licenseExpirationDate,
                            ),
                          ),
                          if (!selectedValues.contains(item))
                            ElevatedButtonWidget.choose(
                              onPressed: () {
                                setState(() {
                                  selectedValues!.add(item);
                                });
                              },
                            ),
                          if (selectedValues.contains(item))
                            ElevatedButtonWidget.primaryCustomBorder(
                              text: "selection_chosen".tr(),
                              onPressed: () {
                                setState(() {
                                  selectedValues.remove(item);
                                });
                              },
                            ),
                          const SizedBox(
                            height: 8,
                          )
                        ],
                      ),
                    );
                  }),
              Align(
                alignment: Alignment.bottomCenter,
                child: EnhancedCustomElevatedButtonWidget(
                  btnColor: selectedValues.isEmpty
                      ? AppColor.black200
                      : AppColor.primary900Light,
                  btnTextColor: selectedValues.isEmpty
                      ? AppColor.black400
                      : AppColor.white,
                  btnPressed: selectedValues.isEmpty
                      ? () {}
                      : () {
                          context.read<PostersLicenseBloc>().add(
                              UpdatePermitsLicenses(
                                  selectedValues: selectedValues));

                          context
                              .read<PostersLicenseBloc>()
                              .add(const ApplyPosterGroupEvent());
                        },
                  btnRadius: 8,
                  btnText: "poster_start_request".tr(),
                  btnTextSize: 16,
                  btnTextWeight: AppFontWeight.bold,
                  btnHeight: 56,
                ),
              ),
              if (state.status == BlocStatus.loading)
                const CustomCircularLoadingWidget(),
            ],
          ),
        ),
      );

      return Container();
    });
  }
}
