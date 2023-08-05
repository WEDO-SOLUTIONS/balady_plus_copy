import 'package:balady_plus/etmam_app/features/services/presentation/blocs/service_details_bloc/service_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/utils_exports.dart'
    show IconPath, PrimaryIcons, trans;
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomVerticalSpace,
        DrawLineWidget,
        EtmamRatingEvaluationWidget,
        SectionTitleWidget,
        SubTitleAndDescWidget,
        SubTitleAndWidget;

class ServiceInfoWidget extends StatelessWidget {
  const ServiceInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
      builder: (context, state) {
        return Container(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SubTitleAndDescWidget(
                  subTitle: trans('service_desc'),
                  desc: state.response.service?.description),
              SubTitleAndWidget(
                subTitle: trans('service_evaluation'),
                // desc: trans('service_evaluation_desc'),
                verticalSpace: 10,
                subTitleIcon: IconPath.subTitleStarIcon,
                widget: EtmamRatingEvaluationWidget(
                  rating: state.response.service?.rating ?? 0,
                  totalEvaluation: state.response.service?.ratingsCount,
                  withIcon: false,
                ),
              ),
              CustomVerticalSpace(height: 12),
              DrawLineWidget(
                lineColor: Color(0xff979797).withOpacity(0.2000000029802322),
              ),
            ]));
      },
    );
  }
}
