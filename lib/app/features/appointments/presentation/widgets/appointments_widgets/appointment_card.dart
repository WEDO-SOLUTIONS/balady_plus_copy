import 'package:flutter/material.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../objectable_transactions/presentation/widgets/request_parameter.dart';
import '../../core/models/appointment_card_item.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentCardItem item;
  final Function onPress;

  const AppointmentCard({super.key, required this.item, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const DrawIconBasedTypeWidget(icon: IconPath.requests),
              CustomHorizontalSpace(
                width: 4,
              ),
              const SizedBox(width: 4),
              CustomTextWidget(
                "appointment".tr(),
                textStyle: AppStyle.cardTitleTextStle,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CustomTextWidget(
                  '#${item.id}',
                  textStyle: AppStyle.requestNumberTextStle,
                  textAlign: TextAlign.start,
                ),
              ),
              HomeTag(
                title: item.statusName ?? "",
                backgroundColor: AppColor.secondary100Light,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              children: [
                RequestParameter(
                  title: 'appointmentsAppointmentServiceWord'.tr(),
                  value: item.mainClassName ?? "",
                ),
                Container(),
                RequestParameter(
                  title: 'appointmentsAppointmentTimeWord'.tr(),
                  value: item.visitTime ?? "",
                ),
                RequestParameter(
                  title: 'appointmentsAppointmentDateWord'.tr(),
                  value: item.visitDate ?? "",
                ),
                RequestParameter(
                  title: 'appointmentsAppointmentAddressWord'.tr(),
                  value:
                      "${item.municipalityName} . ${item.subMunicipalityName}",
                ),
              ],
            ),
          ),
          ElevatedButtonWidget.details(onPressed: () => onPress()),
        ],
      ),
    );
  }
}
