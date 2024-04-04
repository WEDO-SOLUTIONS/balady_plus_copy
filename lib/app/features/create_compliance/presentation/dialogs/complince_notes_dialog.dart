import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../domain/entities/comliance_request_details.dart';
import '../widgets/compliance_clauses_submit_item_widget.dart';

class ComplainceNotesDialog extends StatelessWidget {
  final List<ItemData>? itemData;

  const ComplainceNotesDialog({Key? key, this.itemData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetWithActions(
      title: "prevoius_notes".tr(),
      isList: true,
      searchable: false,
      body: Flexible(
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsetsDirectional.only(start: 12),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColor.primary50Light50,
                        ),
                        child:
                            ComplianceClauseNotesItem(item: itemData![index]),
                      ),
                    ],
                  );
                },
                childCount: itemData?.length ?? 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
