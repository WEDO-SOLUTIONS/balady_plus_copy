import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/location/presentation/bloc/location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermissionDeniedPage extends StatelessWidget {
  const PermissionDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationBloc(),
      child: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: Container(
                child: CustomTextWidget("Permission Denied"),
              ),
            ),
          );
        },
      ),
    );
  }
}
