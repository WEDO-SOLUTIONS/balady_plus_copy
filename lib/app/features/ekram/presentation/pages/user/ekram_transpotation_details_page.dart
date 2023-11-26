import 'package:balady_new_app/app/core/core_exports.dart';
import 'package:balady_new_app/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:balady_new_app/app/features/ekram/presentation/blocs/request_details_bloc/request_details_bloc_bloc.dart';
import 'package:balady_new_app/shared/core/utils/enums/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EkramTransportationDetailsPage extends StatefulWidget {
  final DeceasedRequestDetails params;
  const EkramTransportationDetailsPage({Key? key, required this.params})
      : super(key: key);

  @override
  State<EkramTransportationDetailsPage> createState() =>
      _EkramTransportationDetailsPageState();
}

class _EkramTransportationDetailsPageState
    extends State<EkramTransportationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestDetailsBloc(
          getTrips: sl(),
          details: widget.params,
          getDeceasedDriverRequestDetails: sl(),
          getTripsLocation: sl(),
          isDriver: true),
      child: BlocConsumer<RequestDetailsBloc, RequestDetailsState>(
        listener: (context, state) {
          print("state $state");
          if (state.status == BlocStatus.failure) {
            //   showError(state.errorMessage ?? "");
          }
        },
        builder: (ctx, state) => WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop(state.isCompleted);
            return Future<bool>.value(true);
          },
          child: Scaffold(
            backgroundColor: AppColors.white2,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // header
                EkramDetailsAppBar(
                  title: Helpers.translatingWord("trasferDetailsHeader"),
                  status: state.details.requestStatus ?? "",
                  orderNo: widget.params.requestId.toString(),
                  onExit: () {
                    Navigator.of(context).pop(state.isCompleted);
                  },
                ),
                // body
                const EkramDetailsBodyWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
