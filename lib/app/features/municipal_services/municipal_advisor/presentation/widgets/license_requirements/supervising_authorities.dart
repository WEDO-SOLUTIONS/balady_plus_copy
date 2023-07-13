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
                text: '5. ${"municipalAdvisorAdvertisingOfficesTitle".tr()}\n',
                style: const TextStyle(
                  color: AppColor.darkTurquoise,
                  fontSize: 12,
                  fontFamily: 'Arabic UI Display',
                  fontWeight: FontWeight.w600,
                ),
              ),
              for (final supervisingAuthority in state.supervisingAuthorities ??
                  <SupervisingAuthorityEntity>[]) ...[
                TextSpan(
                  text: '${"authority".tr()}:\n',
                  style: const TextStyle(
                    color: AppColor.darkTurquoise,
                    fontSize: 10,
                    fontFamily: 'Arabic UI Display',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '${supervisingAuthority.agencyName}\n',
                  style: const TextStyle(
                    color: Color(0xFF71717A),
                    fontSize: 10,
                    fontFamily: 'Arabic UI Display',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '${"approvalType".tr()}:\n',
                  style: const TextStyle(
                    color: AppColor.darkTurquoise,
                    fontSize: 10,
                    fontFamily: 'Arabic UI Display',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '${supervisingAuthority.approvalTypeName}\n',
                  style: const TextStyle(
                    color: Color(0xFF71717A),
                    fontSize: 10,
                    fontFamily: 'Arabic UI Display',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
