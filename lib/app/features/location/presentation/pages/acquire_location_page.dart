import 'dart:async';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/location/presentation/bloc/location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/local/bridge.dart';
import '../wisgets/location_retrive_location.dart';
import '../wisgets/location_retrive_data.dart';

class AcquireLocationPage extends StatefulWidget {
  const AcquireLocationPage({super.key});

  @override
  State<AcquireLocationPage> createState() => _AcquireLocationPageState();
}

class _AcquireLocationPageState extends State<AcquireLocationPage> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.resumed) {
      sl<LocationCubit>().getLocationInit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationCubit, LocationState>(
      listener: (context, state) {
        if (state.requestsStatus == BlocStatus.success) {
          if (mounted) {
            Timer(Duration(seconds: 1), () {
              final params = sl<BridgeParams>().copyWith(isAuthenticated: true);
              final entryPointBridge = sl<EntryPointBridge>();
              entryPointBridge(params);

              context.read<LocationCubit>().resetRequestsStatus();
            });
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage(ImagePath.successPageBackground), fit: BoxFit.cover),
            ),
            child: Builder(
              builder: (context) {
                if (state.locationStatus == BlocStatus.success) {
                  return LocationRetriveData();
                }
                //  return Container(
                //     child: Center(child: Text("Getting Location Success")));
                if (state.locationStatus == BlocStatus.loading) {
                  return LocationRetriveData();
                }
                if (state.locationStatus == BlocStatus.failure) {
                  return Center(child: Text("Getting Location"));
                }

                if (state.locationPermissionStatus == BlocStatus.locationPermissionSuceess &&
                    state.locationServiceStatus == BlocStatus.locationServiceSuceess) {
                  return LocationRetriveData();
                }

                if (state.locationServiceStatus == BlocStatus.locationServiceFailed) {
                  return LocationRetriveLocation(permission: false);
                }
                if (state.locationPermissionStatus == BlocStatus.locationPermissionFailed) {
                  return LocationRetriveLocation(permission: true);
                }

                return Center(child: Text(""));
              },
            ),
          ),
        );
      },
    );
  }
}
