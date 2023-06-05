import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocListener, BlocProvider, ReadContext;
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../../core/services/services_exports.dart'
    show EntryPointBridge;
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, BlocStatus, ContextConversion;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show BridgeParams, CustomTextWidget, LoadingDialog, MessageDialog;
import '../../../../entry_point/entry_point_exports.dart' show EntryPointCubit;
import '../../sign_in_exports.dart'
    show SignInBloc, SignInBodyWidget, SignInState;

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (_) => SignInBloc(
        signInByPhoneNumber: sl(),
        signInByUsernameAndPassword: sl(),
        entryPointCubit: context.read<EntryPointCubit>(),
      ),
      child: BlocListener<SignInBloc, SignInState>(
        listener: (_, state) async {
          switch (state.status) {
            case BlocStatus.loading:
              await LoadingDialog.showAnimatedLoading(context);
              break;
            case BlocStatus.closeLoading:
              context.popDialog();
              break;
            case BlocStatus.failure:
              await MessageDialog.showError(context, state.error);
              break;
            case BlocStatus.success:
              onSuccess(context);
              break;
            default:
              break;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: CustomTextWidget(
              "signIn".tr(),
              textStyle: AppStyle.mainTextSecondaryStyle
                  .copyWith(color: AppColor.white),
            ),
          ),
          body: const SignInBodyWidget(),
        ),
      ),
    );
  }

  void onSuccess(BuildContext context) {
    // to move to another screen
    final params = sl<BridgeParams>().copyWith(isAuthenticated: true);
    final entryPointBridge = sl<EntryPointBridge>();
    entryPointBridge(params);
  }
}
