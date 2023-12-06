import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/request_details_bloc/request_details_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class DriverEkramTransportationDetailsPage extends StatefulWidget {
  const DriverEkramTransportationDetailsPage({Key? key}) : super(key: key);

  @override
  State<DriverEkramTransportationDetailsPage> createState() =>
      _DriverEkramTransportationDetailsPageState();
}

class _DriverEkramTransportationDetailsPageState
    extends State<DriverEkramTransportationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    DeceasedRequestDetails params =
        ModalRoute.of(context)!.settings.arguments as DeceasedRequestDetails;

    return BlocProvider(
      create: (context) => RequestDetailsBloc(
          getTrips: sl(),
          details: params,
          getDeceasedDriverRequestDetails: sl(),
          getTripsLocation: sl(),
          isDriver: false),
      child: BlocListener<RequestDetailsBloc, RequestDetailsState>(
        listener: (context, state) {
          print("state $state");
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.white2,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // header
              EkramDetailsAppBar(
                title: ("trasferDetailsHeader").tr(),
                status: params.requestStatus ?? "",
                orderNo: params.requestId.toString(),
              ),
              // body
              const EkramDetailsBodyWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
