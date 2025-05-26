import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../etmam_app/core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../data/model/driver/deceased_identical_item.dart';
import '../../../domain/entities/deceased_request_details/deceased_request_details.dart';
import '../ekram_status_widget.dart';

class IdenticalDeceasedCardWidget extends StatelessWidget {
  final DeceasedIdenticalItem item;
  final bool isDriver;
  // final Function onPressShowTrips;
  // final Function onPressLogTrip;
  // final Function showLocation;
  final bool showLogTrip;

  const IdenticalDeceasedCardWidget(
      {Key? key,
      required this.item,
      required this.isDriver,
      // required this.onPressShowTrips,
      // required this.showLocation,
      // required this.onPressLogTrip,
      required this.showLogTrip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
      width: MediaQuery.of(context).size.width - 60,
      decoration: new BoxDecoration(
          color: AppColor.white, borderRadius: BorderRadius.circular(16)),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 15,),
          EkramHeaderAndDescWidget_With_Background(
                      title: ('deceasedName').tr(),
                      details: item.deceasedName ?? "",
                    ),
          EkramHeaderAndDescWidget_With_Background(
                      title: ('ekram_deceased_id').tr(),
                      details: item.deceasedIdentityId !=null ?"${item.deceasedIdentityId}" :"",
                    ),
          EkramHeaderAndDescWidget_With_Background(
                      title: ('transportationStatus').tr(),
                      details: item.transportCaseName !=null ?"${item.transportCaseName}" :"",
                    ),
          EkramHeaderAndDescWidget_With_Background(
            title: ('deathCity/arrivelCity').tr(),
            details: item.deathCityName !=null ?"${item.deathCityName}" :"",
          ),
          EkramHeaderAndDescWidget_With_Background(
            title: ('burial_city').tr(),
            details: item.burialCityName ?? "",
          ),
          EkramHeaderAndDescWidget_With_Background(
            title: ('ekram_reciever_Mobile').tr(),
            details: item.bodyRecipientMobile ?? "",
          ),
          EkramHeaderAndDescWidget_With_Background(
                      title: ('needSpecialTransfer').tr(),
                      details: (item.needSpecialTransport ?? false)
            ? ("yes").tr()
            : ("no").tr(),
                    ),
          if (item.needSpecialTransport == true)
            EkramHeaderAndDescWidget_With_Background(
                          title: ('reasonForSpecialTransfer').tr(),
                          details: item.getSpecialTransferReason(),
                        ),
        ],
      ),
    );
  }
}
