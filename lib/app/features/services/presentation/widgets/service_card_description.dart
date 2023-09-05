import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/service_cards/service_card_desc_widget.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/service_cards/service_card_req_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget;
import '../../services_exports.dart'
    show ServiceCardParameter, ServiceCardsCubit, ServiceCardsState;
import 'service_cards/service_card_flow_widget.dart';

class ServiceCardDescription extends StatelessWidget {
  const ServiceCardDescription({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceCardsCubit, ServiceCardsState>(
      builder: (context, state) {
        final card = state.selectedCard;
        if (card == null) {
          return const SizedBox();
        }

        if (card.type == ServiceCardsTypes.desc)
          return const ServiceCardDescWidget();
        if (card.type == ServiceCardsTypes.req)
          return const ServiceCardReqWidget();
        if (card.type == ServiceCardsTypes.flow)
          return const ServiceCardFlowWidget();

        return Container();
      },
    );
  }
}
