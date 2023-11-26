import 'package:balady_new_app/app/core/core_exports.dart' show Constants;
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';

class EkramDetailsBodyWidget extends StatelessWidget {
  const EkramDetailsBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        [
          Constants.verticalSpaceSmall,
          // TransferInfo
          TransferInfoWidget(),
          // DriversInfo
          //  DriversInfoWidget(),
          // ApplicantInfo
          ApplicantInfoWidget(),
          // DeceasedInfo
          DeceasedInfoWidget(),
          // BurialInfo
          //  BurialInfoWidget(),
          Constants.verticalSpaceSmall,
        ],
      ),
    );
  }
}
