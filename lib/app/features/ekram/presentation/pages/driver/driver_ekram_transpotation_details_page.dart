import 'package:balady_new_app/app/core/core_exports.dart';
import 'package:balady_new_app/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:balady_new_app/app/features/ekram/presentation/blocs/request_details_bloc/request_details_bloc_bloc.dart';
import 'package:balady_new_app/shared/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverEkramTransportationDetailsPage extends StatefulWidget {
  final DeceasedRequestDetails params;
  const DriverEkramTransportationDetailsPage({Key? key, required this.params})
      : super(key: key);

  @override
  State<DriverEkramTransportationDetailsPage> createState() =>
      _DriverEkramTransportationDetailsPageState();
}

class _DriverEkramTransportationDetailsPageState
    extends State<DriverEkramTransportationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestDetailsBloc(
          getTrips: sl(),
          details: widget.params,
          getDeceasedDriverRequestDetails: sl(),
          getTripsLocation: sl(),
          isDriver: false),
      child: BlocListener<RequestDetailsBloc, RequestDetailsState>(
        listener: (context, state) {
          print("state $state");
          if (state.status == BlocStatus.failure) {
            showError(state.errorMessage ?? "");
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.white2,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // header
              EkramDetailsAppBar(
                title: Helpers.translatingWord("trasferDetailsHeader"),
                status: widget.params.requestStatus ?? "",
                orderNo: widget.params.requestId.toString(),
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
