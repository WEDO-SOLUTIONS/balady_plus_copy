import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_analytics_events.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../data/models/new_ticket_page_args.dart';
import '../core/bloc/new_ticket_bloc/new_daem_ticket_bloc.dart';
import '../widgets/details_app_bar.dart';

class NewDaemPage extends StatefulWidget {
  const NewDaemPage({super.key});

  @override
  State<NewDaemPage> createState() => _NewDaemPageState();
}

class _NewDaemPageState extends State<NewDaemPage> {
  @override
  void initState() {
    super.initState();
    //MM  Helpers.sendEventToAnalytics(AppEvents.VD_Open_Details);

    CommonFunctions.sendEventToAnalytics(AppEvents.Daem);
    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceDaem);

    CommonFunctions.sendUXCamEvent(UXCamEvents.Daem_Open_Create_Details_Event);
  }

  @override
  Widget build(BuildContext context) {
    NewTicketPageArgs args =
        ModalRoute.of(context)!.settings.arguments as NewTicketPageArgs;

    return BlocProvider<NewDaemTicketBloc>(
      create: (context) => NewDaemTicketBloc(
          category: args.category,
          subCategoryTypeList: args.subCategoryTypeList,
          municipalities: args.municipalities,
          areaList: args.areaList,
          issueypeList: args.issuesList,
          subCategory: args.subCategory,
          area: args.area,
          issue: args.issueType),
      child: BlocConsumer<NewDaemTicketBloc, NewDaemTicketState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.error ?? "");
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              context.read<NewDaemTicketBloc>().add(GoToPreviousPageEvent());
              return Future<bool>.value(false);
            },
            child: GestureDetector(
              onTap: () {
                context.read<NewDaemTicketBloc>().hideKeyboard();
              },
              child: Scaffold(
                appBar: DetailsAppBar(
                  currentStep: state.currentPageValue + 1,
                  backOnPress: () => context
                      .read<NewDaemTicketBloc>()
                      .add(GoToPreviousPageEvent()),
                ),
                body: Stack(
                  children: [
                    PageView.builder(
                        itemCount:
                            context.read<NewDaemTicketBloc>().pagesList.length,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        controller:
                            context.read<NewDaemTicketBloc>().controller,
                        itemBuilder: (context, position) {
                          return AnimatedContainer(
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 300),
                            child: context
                                .read<NewDaemTicketBloc>()
                                .pagesList[position],
                          );
                        }),
                    if (state.status == BlocStatus.loading)
                      const CustomCircularLoadingWidget(),
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
