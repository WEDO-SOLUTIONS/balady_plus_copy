/*import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/location/presentation/bloc/location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/enums/bloc_status.dart';

class PermissionDeniedPage extends StatelessWidget {
  const PermissionDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationBloc(),
      child: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state.locationPermissionStatus ==
              BlocStatus.locationPermissionSuceess)
            return Container(
                child: Center(
                    child: CustomTextWidget(
                        "Getting Location Prmission Success")));

          if (state.locationPermissionStatus ==
              BlocStatus.locationServiceSuceess)
            return Container(
                child: Center(
                    child:
                        CustomTextWidget("Getting Location Service Success")));

          if (state.locationPermissionStatus == BlocStatus.loading)
            return Container(child: Center(child: CustomTextWidget("Loading")));
          if (state.locationPermissionStatus ==
              BlocStatus.locationPermissionFailed)
            return Container(
                child: Center(
                    child:
                        CustomTextWidget("Getting Location Prmission Failed")));

          if (state.locationPermissionStatus ==
              BlocStatus.locationServiceFailed)
            return Container(
                child: Center(
                    child:
                        CustomTextWidget("Getting Location Service Failed")));
          return Container();
        },
      ),
    );
  }
}
*/
