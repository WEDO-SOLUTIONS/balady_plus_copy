import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextFieldWidget, MessageDialog;
import '../../../../home_page/home_exports.dart' show CircleIcon;
import '../../municipal_advisor_exports.dart'
    show
        MunicipalAdvisorAddMessageEvent,
        MunicipalAdvisorBloc,
        MunicipalAdvisorState,
        MunicipalAdvisorSteps;

class SendMessageCard extends StatefulWidget {
  const SendMessageCard({super.key});

  @override
  State<SendMessageCard> createState() => _SendMessageCardState();
}

class _SendMessageCardState extends State<SendMessageCard> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        top: false,
        child: BlocConsumer<MunicipalAdvisorBloc, MunicipalAdvisorState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (_, state) async {
            if (state.error.isNotEmpty &&
                (state.status == BlocRequestStatus.submissionGetFailure ||
                    state.status == BlocRequestStatus.failure)) {
              MessageDialog.showErrorNotification(msg: state.error);
            }
          },
          buildWhen: (previous, current) =>
              previous.messages.isEmpty && current.messages.isNotEmpty,
          builder: (context, state) {
            return IgnorePointer(
              ignoring: state.messages.isNotEmpty,
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFieldWidget(
                      hintText: 'chatHint'.tr(),
                      controller: _controller,
                      borderRadius: 8,
                      fillColor: AppColor.blackModern100Light,
                      borderColor: AppColor.blackModern100Light,
                      onSubmitted: sendMessage,
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: sendMessage,
                    child: const CircleIcon(
                      icon: IconPath.send,
                      iconSize: 24,
                      circleSize: 40,
                      backgroundColor: AppColor.primary900Light,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void sendMessage([String? message]) {
    final text = message ?? _controller.text;
    if (text.isEmpty) return;
    context.read<MunicipalAdvisorBloc>().add(
          MunicipalAdvisorAddMessageEvent(
            message: text,
            step: MunicipalAdvisorSteps.start,
          ),
        );
    _controller.text = '';
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
