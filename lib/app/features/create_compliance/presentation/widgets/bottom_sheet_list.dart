import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_bloc.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../domain/entities/complinace_licenses_response.dart';
import 'license_item_widget.dart';

class LicenseBottomSheetList extends StatefulWidget {
  final String title;
  final List<ComplianceLisenseItem> items;
  final ComplianceLisenseItem? selectedValue;
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
  late List<ComplianceLisenseItem> items;
  ComplianceLisenseItem? selectedValue;

  @override
  void initState() {
    super.initState();
    items = widget.items;
    selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
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
                    onTap: () => selectItem(item),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsetsDirectional.only(start: 12),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColor.primary50Light50,
                          ),
                          child: ComplianceLicenseItemWidget(
                            licenseNo: "${item.licenseId?.toInt()}",
                            licenseType: item.licenseType,
                            municipality: item.municipalityName,
                            status: item.statusName,
                            dueDate: item.issuingDate,
                            expiryDate: item.expirationDate,
                          ),
                        ),
                        ElevatedButtonWidget.choose(
                          onPressed: () {
                            selectedValue = item;

                            if (selectedValue != null) {
                              widget.onTap!(selectedValue!);
                            }
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
  }

  void selectItem(ComplianceLisenseItem item) {
    setState(() {
      selectedValue = item;
    });
  }
}
