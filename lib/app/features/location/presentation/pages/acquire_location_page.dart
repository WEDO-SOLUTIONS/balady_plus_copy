import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/location/presentation/bloc/location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcquireLocation extends StatelessWidget {
  const AcquireLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationBloc(),
      child: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Container(
            child: Center(child: CustomTextWidget("Getting Location")),
          );
        },
      ),
    );
  }
}
