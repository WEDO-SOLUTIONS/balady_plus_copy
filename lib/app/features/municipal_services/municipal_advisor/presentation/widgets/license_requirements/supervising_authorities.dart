import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart';
import '../../../municipal_advisor_exports.dart';

class SupervisingAuthorities extends StatelessWidget {
  const SupervisingAuthorities({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text:
                    '5. ${"municipalAdvisorSupervisingAuthoritiesTitle".tr()}\n',
                style: AppStyle.lightTitleTextStyle.copyWith(fontSize: 12),
              ),
              for (final supervisingAuthority
                  in state.supervisingAuthorities) ...[
                TextSpan(
                  text: '${"authority".tr()}:\n',
                  style: AppStyle.lightTitleTextStyle,
                ),
                TextSpan(
                  text: '${supervisingAuthority.agencyName}\n',
                  style: AppStyle.lightTextStyle,
                ),
                TextSpan(
                  text: '${"approvalType".tr()}:\n',
                  style: AppStyle.lightTitleTextStyle,
                ),
                TextSpan(
                  text: '${supervisingAuthority.approvalTypeName}\n',
                  style: AppStyle.lightTextStyle,
                ),
              ],
              if (state.supervisingAuthorities.isEmpty)
                TextSpan(
                  text: '${"noData".tr()}\n',
                  style: AppStyle.lightTextStyle,
                ),
            ],
          ),
        );
      },
    );
  }
}
