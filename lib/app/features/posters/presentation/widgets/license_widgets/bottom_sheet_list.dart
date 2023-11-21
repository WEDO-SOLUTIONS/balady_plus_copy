import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';

import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
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
  List<PermitsLicensesItem> items = [];
  List<PermitsLicensesItem> selectedValues = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostersLicenseBloc(groupId: widget.groupId)
        ..add(const GetLicensePermitsEvents()),
      child: BlocConsumer<PostersLicenseBloc, PostersLicenseState>(
        listener: (context, state) {
          // TODO: implement listener

          if (state.status == BlocStatus.success && items.isEmpty) {
            items = state.permitsLiceses ?? [];
          }
        },
        builder: (context, state) {
          return BottomSheetWithActions(
            title: "posters_licenses_list".tr(),
            isList: true,
            searchable: false,
            backgroundColor: AppColor.scaffoldBackground,
            onSearchChanged: (String? text) {
              setState(() {
                items = (state.permitsLiceses ?? [])
                    .where((element) => element.licenseId
                        .toString()
                        .toLowerCase()
                        .contains(text ?? ""))
                    .toList();
              });
            },
            body: Flexible(
              child: Container(
                child: Stack(
                  children: [
                    CustomScrollView(
                      shrinkWrap: true,
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = items[index];
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
                                        text: "تم الإختيار",
                                        onPressed: () {
                                          setState(() {
                                            selectedValues!.remove(item);
                                          });
                                        },
                                      ),
                                    const SizedBox(
                                      height: 8,
                                    )
                                  ],
                                ),
                              );
                            },
                            childCount: items.length,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButtonWidget.primaryCustom(
                          text: "بدء الطلب",
                          onPressed: () {
                            print(selectedValues.length);
                            context.read<PostersLicenseBloc>().add(
                                UpdatePermitsLicenses(
                                    selectedValues: selectedValues));

                            context
                                .read<PostersLicenseBloc>()
                                .add(const ApplyPosterGroupEvent());
                          }),
                    ),
                    if (state.status == BlocStatus.loading)
                      const CustomCircularLoadingWidget(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
