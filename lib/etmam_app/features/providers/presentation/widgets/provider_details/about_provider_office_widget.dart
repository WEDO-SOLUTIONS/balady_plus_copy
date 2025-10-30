import 'package:balady_plus/etmam_app/features/providers/presentation/blocs/provider_details_bloc/provider_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show AboutOfficeWidget, DrawLineWidget;

/*class AboutProviderOfficeWidget extends StatelessWidget {
  const AboutProviderOfficeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderDetailsBloc, ProviderDetailsState>(
      builder: (context, state) {
        return Container(
            decoration: const BoxDecoration(
              color: AppColor.white,
              boxShadow: [
                BoxShadow(
                    color: Color(0x14d1d5db),
                    offset: Offset(-2, 4),
                    blurRadius: 8,
                    spreadRadius: 0)
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: AboutOfficeWidget(
                aboutOfficeDesc: state.args.description,
                workingHours: state.args.wrokDays,
                website: state.args.website,
                mobile: state.args.mainBranchContact,
                socialMedia: state.args.socialMediaAccounts,
              ),
            ));
      },
    );
  }
}*/

class AboutProviderOfficeWidget extends StatelessWidget {
  const AboutProviderOfficeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderDetailsBloc, ProviderDetailsState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: AboutOfficeWidget(
            aboutOfficeDesc: state.args.description,
            workingHours: state.args.wrokDays,
            website: state.args.website,
            mobile: state.args.mainBranchContact,
            socialMedia: state.args.socialMediaAccounts,
            showDivider: true,
          ),
        );
      },
    );
  }
}
