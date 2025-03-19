import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/fields/read_only_field.dart';
import 'package:balady_plus/app/features/ceritified_observer/domain/lookups.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AdditionalInfoWidget extends StatelessWidget {
  final ChooseMuncipalityState state;

  const AdditionalInfoWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'vd_user_info'.tr(),
      children: SurveyQuestion.values
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.name.tr()),
                  Row(
                    children: [
                      Expanded(
                          child: Card(
                        color: Colors.grey.shade100,
                        child: Row(
                          children: [
                            Radio(
                              value: false,
                              groupValue: false,
                              onChanged: (vlaue) {},
                            ),
                            Text("yes".tr()),
                          ],
                        ),
                      )),
                      Expanded(
                          child: Card(
                        color: Colors.grey.shade100,
                        child: Row(
                          children: [
                            Radio(
                              value: true,
                              groupValue: false,
                              onChanged: (vlaue) {},
                            ),
                            Text("no".tr()),
                          ],
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
