import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';

import '../../../data/models/permit_license_response_model.dart';
import '../../blocs/posters_license_bloc.dart';
import 'license_item_widget.dart';

class LicenseBottomSheetList extends StatefulWidget {
  final String title;
  final List<PermitsLicensesItem> items;
  final PermitsLicensesItem? selectedValue;
  final void Function(dynamic)? onTap;
  final bool searchable;

  const LicenseBottomSheetList({
    super.key,
    required this.title,
    required this.items,
    this.selectedValue,
    required this.onTap,
    this.searchable = true,
  });

  @override
  State<LicenseBottomSheetList> createState() => _LicenseBottomSheetListState();
}

class _LicenseBottomSheetListState extends State<LicenseBottomSheetList> {
  late List<PermitsLicensesItem> items;
  List<PermitsLicensesItem>? selectedValues;

  @override
  void initState() {
    super.initState();
    items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostersLicenseBloc(),
      child: BlocConsumer<PostersLicenseBloc, PostersLicenseState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return BottomSheetWithActions(
            title: widget.title,
            isList: true,
            searchable: widget.searchable,
            onSearchChanged: (String? text) {
              setState(() {
                items = widget.items
                    .where((element) => element.licenseId
                        .toString()
                        .toLowerCase()
                        .contains(text ?? ""))
                    .toList();
              });
            },
            body: Flexible(
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = items[index];
                        return InkWell(
                          onTap: () {
                            selectedValues!.add(item);
                          },
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsetsDirectional.only(start: 12),
                                margin: const EdgeInsets.symmetric(vertical: 8),
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
                              ElevatedButtonWidget.choose(
                                onPressed: () {
                                  selectedValues!.add(item);
                                },
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
            ),
          );
        },
      ),
    );
  }
}
