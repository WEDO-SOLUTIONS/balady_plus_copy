import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../municipal_advisor_exports.dart'
    show MunicipalAdvisorBloc, MunicipalAdvisorState;

class InputSummary extends StatelessWidget {
  const InputSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "${"location".tr()}: ",
                style: const TextStyle(
                  color: Color(0xFF036362),
                  fontSize: 12,
                  fontFamily: 'Arabic UI Display',
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ' ${state.activityLocation?.gisResponse} \n\n',
                style: const TextStyle(
                  color: Color(0xFF3F3F46),
                  fontSize: 12,
                  fontFamily: 'Arabic UI Display',
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: "${'isicActivity'.tr()}: ",
                style: const TextStyle(
                  color: Color(0xFF036362),
                  fontSize: 12,
                  fontFamily: 'Arabic UI Display',
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: '${state.selectedIsicActivity?.name} \n\n',
                style: const TextStyle(
                  color: Color(0xFF3F3F46),
                  fontSize: 12,
                  fontFamily: 'Arabic UI Display',
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: "${'subActivity'.tr()}: ",
                style: const TextStyle(
                  color: Color(0xFF036362),
                  fontSize: 12,
                  fontFamily: 'Arabic UI Display',
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ' ${state.selectedIsicSubActivity?.name}\n\n',
                style: const TextStyle(
                  color: Color(0xFF3F3F46),
                  fontSize: 12,
                  fontFamily: 'Arabic UI Display',
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: "${'facilityType'.tr()}: ",
                style: const TextStyle(
                  color: Color(0xFF036362),
                  fontSize: 12,
                  fontFamily: 'Arabic UI Display',
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ' ${state.activityDetails!.facilityName}\n\n',
                style: const TextStyle(
                  color: Color(0xFF3F3F46),
                  fontSize: 12,
                  fontFamily: 'Arabic UI Display',
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: "${'facilityArea'.tr()}: ",
                style: const TextStyle(
                  color: Color(0xFF036362),
                  fontSize: 12,
                  fontFamily: 'Arabic UI Display',
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text:
                    ' ${state.selectedArea?.toStringAsFixed(0)} ${'m2'.tr()}\n',
                style: const TextStyle(
                  color: Color(0xFF3F3F46),
                  fontSize: 12,
                  fontFamily: 'Arabic UI Display',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.right,
        );
      },
    );
  }
}
