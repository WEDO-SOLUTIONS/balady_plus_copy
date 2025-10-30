import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/etmam_app/features/providers/presentation/blocs/provider_details_bloc/provider_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, PrimaryIcons, RouteName, trans;
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomVerticalSpace, HeaderWithViewAllWidget, SectionTitleWidget;
import '../../../../services/services_exports.dart' show PreviousWorkCard;

class ProviderPreviousWorksWidgets extends StatelessWidget {
  const ProviderPreviousWorksWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderDetailsBloc, ProviderDetailsState>(
      builder: (context, state) {
        return (state.args.projects?.length ?? 0) > 0
            ? Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitleWidget(
                        title: trans('previous_works'),
                        primaryIcon: PrimaryIcons.providerWorksIcon,
                      ),
                      HeaderWithViewAllWidget(
                        headerText: trans('previous_works_desc'),
                        headerTextColor: AppColor.bottomNavigationShadow,
                        headerTextSize: 12,
                        headerFontWeight: AppFontWeight.regular,
                        margin: EdgeInsets.zero,
                        showAllButton: (state.args.projects?.length ?? 0) > 3,
                        btnPressed: () {
                          NavigationService.pushNamed(
                              routeName: EtmamRoutesNames.previousWorksPage,
                              args: state.args.projects);
                        },
                      ),
                      const CustomVerticalSpace(height: 24),
                      SizedBox(
                          height: 190,
                          child: ListView.builder(
                              clipBehavior: Clip.none,
                              itemCount: (state.args.projects?.length ?? 0) > 3
                                  ? 3
                                  : (state.args.projects?.length ?? 0),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, index) {
                                return PreviousWorkCard(
                                    project: state.args.projects?[index]);
                              })),
                    ]))
            : Container();
      },
    );
  }
}
