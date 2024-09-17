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
      'dd/MM/yyyy',
      "locale".tr(),
    ).format(parsedDate);
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
                  const SizedBox(width: 8),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(classificationCertificate.facilityName),
                  ),
                  Chip(
                    padding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      side: BorderSide(
                        width: 1,
                        color: Colors.blueAccent,
                      ),
                    ),
                    backgroundColor: Colors.blueAccent.withAlpha(70),
                    label: Text(
                      'التصنيف A',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.blueAccent,
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
}
