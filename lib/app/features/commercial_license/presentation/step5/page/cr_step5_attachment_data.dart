import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../commercial_license_exports.dart';

class CRStep5AttachmentData extends StatelessWidget {
  const CRStep5AttachmentData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CRHeaderDesc(
                    maxLines: null,
                    textHeight: 1.5,
                    header: "step5title".tr(),
                    desc: "step5titleDesc".tr(),
                  ),
                  const SizedBox(height: 12),
                  PickFileComponent(
                    title: "step5license".tr(),
                    file: null,
                    onDelete: () {},
                    onPickedFile: (file) {},
                  ),
                  PickFileComponent(
                    title: 'step5LicnesePic'.tr(),
                    file: null,
                    onDelete: () {},
                    onPickedFile: (file) {},
                  ),
                  PickFileComponent(
                    title: "invest_contract".tr(),
                    file: null,
                    onDelete: () {},
                    onPickedFile: (file) {},
                  ),
                  PickFileComponent(
                    title: 'owner_proof'.tr(),
                    file: null,
                    onDelete: () {},
                    onPickedFile: (file) {},
                  ),
                ],
              ),
            ),
          ),
        ),
        const CRPreviousNextButtons(isBtnDisabled: false),
      ],
    );
  }
}
