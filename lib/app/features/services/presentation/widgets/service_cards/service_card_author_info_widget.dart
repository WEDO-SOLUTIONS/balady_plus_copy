import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_buttons_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../cubit/service_cards_cubit/service_cards_cubit.dart';
import '../service_card_parameter.dart';

class ServiceCardAuthorInfoWidget extends StatelessWidget {
  const ServiceCardAuthorInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceCardsCubit, ServiceCardsState>(
        builder: (context, state) {
      final card = state.selectedCard;
      if (card == null) {
        return const SizedBox();
      }

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: AppColor.darkSlateBlue6,
              offset: Offset(0, -4),
              blurRadius: 32,
            )
          ],
          color: AppColor.blackModern50Light,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const DrawIconBasedTypeWidget(
                  icon: IconPath.menuIcon,
                ),
                const SizedBox(width: 4),
                CustomTextWidget(
                  card.title,
                  textStyle: AppStyle.cardTitleTextStle,
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomUnderlineTextdButtonWidget(
              onPressed: () => launchUrl(Uri.parse(card.descriptionLink ??
                  'https://balady.gov.sa/sites/default/files/2023-06/%D8%AC%D8%AF%D9%88%D9%84%20%D8%A7%D9%84%D8%AC%D8%B2%D8%A7%D8%A1%D8%A7%D8%AA%20%D8%B9%D9%86%20%D8%A7%D9%84%D9%85%D8%AE%D8%A7%D9%84%D9%81%D8%A7%D8%AA%20%D8%A7%D9%84%D8%A8%D9%84%D8%AF%D9%8A%D8%A9.pdf')),
              text: card.description,
            ),
            const SizedBox(height: 16),
            if (card.feesLink != null)
              CustomUnderlineTextdButtonWidget(
                onPressed: () => launchUrl(Uri.parse(card.feesLink!)),
                text: card.feesName ?? "",
              ),
          ],
        ),
      );
    });
  }
}
