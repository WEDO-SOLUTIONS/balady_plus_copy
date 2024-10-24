import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/classification_certificate/core/classification_certificate_routes/classification_certificate_route_names.dart';
import 'package:balady_plus/app/features/classification_certificate/domain/entity/classification_certificate_list_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'title_value_item_widget.dart';

class ClassificationCertificateItemWidget extends StatelessWidget {
  final ClassificationCertificateItemEntity classificationCertificate;

  const ClassificationCertificateItemWidget({
    super.key,
    required this.classificationCertificate,
  });

  @override
  Widget build(BuildContext context) {
    String dataEn = Helpers.changeToEnglish(
      classificationCertificate.certificateExpirationDate,
    );
    DateTime parsedDate = DateTime.parse(dataEn);
    String formattedDate = DateFormat(
      "locale".tr() == "ar" ? 'yyyy/MM/dd' : 'dd/MM/yyyy',
      "locale".tr(),
    ).format(parsedDate);
    Color color = getColorByClassificationGrade(
        classificationCertificate.classificationGrade);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          ClassificationCertificateRouteName
              .classificationCertificateDetailsScreen,
          arguments: classificationCertificate.toJson(),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(top: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset(IconPath.newOfficeIcon),
                  const SizedBox(width: 4),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(classificationCertificate.facilityName),
                  ),
                  const SizedBox(width: 4),
                  Chip(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      side: BorderSide(width: 1, color: color),
                    ),
                    backgroundColor: color.withAlpha(70),
                    label: Text(
                      "ClassificationGrade-${classificationCertificate.classificationGrade}"
                          .tr(),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: color,
                            fontSize: 10,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TitleValueItemWidget(
                title: 'serialNumber',
                value: classificationCertificate.serialNumber,
              ),
              const SizedBox(height: 8),
              TitleValueItemWidget(
                title: 'cRorLicNumber',
                value: classificationCertificate.cRorLicNumber,
              ),
              const SizedBox(height: 8),
              TitleValueItemWidget(
                title: 'expiry_data',
                value: formattedDate,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getColorByClassificationGrade(String grade) {
    switch (grade) {
      case "1":
        return const Color(0xff17A2B8);
      case "2":
        return const Color(0xff3B3A99);
      case "3":
        return const Color(0xff7B56B9);
      case "4":
        return const Color(0xffCE9B00);
      case "5":
        return Colors.grey.shade600;
      case "6":
        return Colors.green.shade700;
    }
    return Colors.cyan.shade600;
  }
}
