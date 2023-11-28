import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';
import '../../blocs/ekram_requests_bloc/ekram_requests_bloc.dart';
import '../../widgets/ekram_book_cemetry/cemetry_request_app_bar.dart';

class EkramBookCemetryPage extends StatefulWidget {
  const EkramBookCemetryPage({
    super.key,
  });

  @override
  State<EkramBookCemetryPage> createState() => _EkramBookCemetryPageState();
}

class _EkramBookCemetryPageState extends State<EkramBookCemetryPage> {
  @override
  Widget build(BuildContext context) {
    EkramRequestsBloc? ekramRequestsBloc =
        ModalRoute.of(context)!.settings.arguments as EkramRequestsBloc?;

    return BlocProvider(
      create: (context) => EkramBookCemetryBloc(
          getCities: sl(),

          // applyDeceasedTransport: sl(),
          getEkramLookUp: sl(),
          checkUserInfo: sl(),
          getCemetries: sl(),
          bookCemetry: sl(),
          ekramRequestsBloc: ekramRequestsBloc),
      child: BlocConsumer<EkramBookCemetryBloc, EkramBookCemetryState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          print(state.currentPageValue);
          return WillPopScope(
            onWillPop: () {
              context.read<EkramBookCemetryBloc>().add(GoToPreviousPageEvent());
              return Future<bool>.value(false);
            },
            child: GestureDetector(
              onTap: () {
                context.read<EkramBookCemetryBloc>().hideKeyboard();
              },
              child: Scaffold(
                appBar: CemetryRequestAppBar(
                  currentStep: state.currentPageValue + 1,
                  backOnPress: () => context
                      .read<EkramBookCemetryBloc>()
                      .add(GoToPreviousPageEvent()),
                ),
                body: Stack(
                  children: [
                    PageView.builder(
                        itemCount: context
                            .read<EkramBookCemetryBloc>()
                            .pagesList
                            .length,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        controller:
                            context.read<EkramBookCemetryBloc>().controller,
                        itemBuilder: (context, position) {
                          return AnimatedContainer(
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 300),
                            child: context
                                .read<EkramBookCemetryBloc>()
                                .pagesList[position],
                          );
                        }),
                    if (state.status == BlocStatus.loading)
                      CustomCircularLoadingWidget(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
