import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show CommonFunctions, IconPath, SocialMediaTypes, trans;
import '../../../../services/domain/entities/service_details/service_details_response.dart';
import '../../shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomIconButtonWidget,
        SocialMediaPrimaryIconWidget,
        SubTitleAndWidget;

class SocialMediaWidget extends StatelessWidget {
  final List<SocialMediaAccount>? socialMedia;

  const SocialMediaWidget({Key? key, required this.socialMedia})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SubTitleAndWidget(
      subTitle: trans('office_social_media'),
      subTitleIcon: IconPath.phoneIcon,
      widget: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 50,
        child: Center(
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: socialMedia?.length ?? 0,
            itemBuilder: (ctx, index) {
              return socialMedia?[index].socialInfo != null
                  ? SocialMediaButton(
                      socialMediaTypes: socialMedia![index].socialInfo!,
                      socialMediaAccount: socialMedia?[index].account,
                    )
                  : Container();
            },
            separatorBuilder: (ctx, index) {
              return const CustomHorizontalSpace(width: 20);
            },
          ),
        ),
/*            Row(
          children: socialMediaTypesList
              .map((s) => Expanded(
                child: SocialMediaButton(
                  socialMediaTypes: s,
                  socialMediaUrl: url,
                ),
              ))
              .toList(),
        ),*/
      ),
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  final SocialMediaTypes socialMediaTypes;
  final String? socialMediaAccount;

  const SocialMediaButton(
      {Key? key, required this.socialMediaTypes, this.socialMediaAccount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomIconButtonWidget(
        padding: EdgeInsets.zero,
        btnPressed: () {
          if (socialMediaAccount != null) {
            if (socialMediaTypes == SocialMediaTypes.whatsapp) {
              String whatsappUrl =
                  "whatsapp://send?phone=${socialMediaAccount}";
              CommonFunctions.launch(whatsappUrl);
            } else {
              CommonFunctions.launch(socialMediaAccount!);
            }
          } else {
            CommonFunctions.showError(trans('no_link_error'));
          }
        },
        icon: SocialMediaPrimaryIconWidget(
          type: socialMediaTypes,
        ));
  }
}
