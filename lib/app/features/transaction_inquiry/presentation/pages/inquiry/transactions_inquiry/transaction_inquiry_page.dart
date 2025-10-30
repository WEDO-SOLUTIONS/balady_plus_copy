import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../core/bloc/transaction_inquiry_bloc/transaction_inquiry_bloc.dart';
import '../../../core/view_models/inquiry/transaction_inquiry_view_model.dart';
import 'details_app_bar.dart';

class NewTransactionPage extends StatefulWidget {
  const NewTransactionPage({super.key});

  @override
  State<NewTransactionPage> createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransactionPage> {
  @override
  void initState() {
    super.initState();
    //MM  Helpers.sendEventToAnalytics(AppEvents.VD_Open_Details);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionInquiryBloc>(
      create: (context) => TransactionInquiryBloc(),
      child: BlocConsumer<TransactionInquiryBloc, TransactionInquiryState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              context
                  .read<TransactionInquiryBloc>()
                  .add(GoToPreviousPageEvent());
              return Future<bool>.value(false);
            },
            child: GestureDetector(
              onTap: () {
                context.read<TransactionInquiryBloc>().hideKeyboard();
              },
              child: Scaffold(
                appBar: DetailsAppBar(
                  currentStep: state.currentPageValue + 1,
                  backOnPress: () => context
                      .read<TransactionInquiryBloc>()
                      .add(GoToPreviousPageEvent()),
                ),
                body: ChangeNotifierProvider<TransactionInquiryViewModel>(
                  create: (context) => TransactionInquiryViewModel(),
                  builder: (context, child) {
                    TransactionInquiryViewModel model =
                        Provider.of<TransactionInquiryViewModel>(context,
                            listen: true);
                    return Stack(
                      children: [
                        PageView.builder(
                            itemCount: context
                                .read<TransactionInquiryBloc>()
                                .pagesList
                                .length,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            controller: context
                                .read<TransactionInquiryBloc>()
                                .controller,
                            itemBuilder: (context, position) {
                              return AnimatedContainer(
                                curve: Curves.easeIn,
                                duration: Duration(milliseconds: 300),
                                child: context
                                    .read<TransactionInquiryBloc>()
                                    .pagesList[position],
                              );
                            }),
                        if (state.status == BlocStatus.loading)
                          const CustomCircularLoadingWidget(),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
