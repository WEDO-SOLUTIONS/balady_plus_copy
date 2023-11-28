import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/request_details_bloc/request_details_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/bloc_status.dart';

class EkramTransportationDetailsPage extends StatefulWidget {
  const EkramTransportationDetailsPage({Key? key}) : super(key: key);

  @override
  State<EkramTransportationDetailsPage> createState() =>
      _EkramTransportationDetailsPageState();
}

class _EkramTransportationDetailsPageState
    extends State<EkramTransportationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    DeceasedRequestDetails? params =
        ModalRoute.of(context)!.settings.arguments as DeceasedRequestDetails?;

    return BlocProvider(
      create: (context) => RequestDetailsBloc(
          getTrips: sl(),
          details: params!,
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
            backgroundColor: AppColor.white2,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // header
                EkramDetailsAppBar(
                  title: Helpers.translatingWord("trasferDetailsHeader"),
                  status: state.details.requestStatus ?? "",
                  orderNo: params!.requestId.toString(),
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
