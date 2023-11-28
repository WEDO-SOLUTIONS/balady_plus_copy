import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
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
