import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show DefaultAppBarWidget;
import '../../municipal_advisor_exports.dart'
    show
        ChatList,
        CloseChatPopup,
        EmptyChat,
        MunicipalAdvisorBloc,
        SendMessageCard;

class MunicipalAdvisorPage extends StatelessWidget {
  const MunicipalAdvisorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: 'municipal_advisor'.tr(),
        x: true,
        onBack: () {
          showDialog(
            context: context,
            builder: (_) => const CloseChatPopup(),
          );
        },
      ),
      body: BlocProvider(
        create: (context) => sl<MunicipalAdvisorBloc>(),
        child: const Column(
          children: [
            EmptyChat(),
            ChatList(),
            SendMessageCard(),
          ],
        ),
      ),
    );
  }
}
