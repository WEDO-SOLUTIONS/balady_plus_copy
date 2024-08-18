import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../features/services/services_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import '../../data/models/service_card.dart';

import '../../../../../features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../../../features/_shared_feature_/presentation/dialogs/not_authorized_indivivisual.dart';
import '../blocs/posters_license_bloc.dart';

class PostersStartService extends StatefulWidget {
  const PostersStartService({Key? key}) : super(key: key);

  @override
  State<PostersStartService> createState() => _PostersStartServiceState();
}

class _PostersStartServiceState extends State<PostersStartService> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.startCardServiceMultiplePostersPermit);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Posters_Open_Service_Card_For_Multiple_Event);
  }

  @override
  Widget build(BuildContext context) {
    ServiceEntity service = postersModel();

    PostersLicenseBloc? bloc =
        ModalRoute.of(context)!.settings.arguments as PostersLicenseBloc?;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ServiceCardsCubit(service),
        ),
      ],
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: service.title.tr(),
          bottom: ServiceCardsList(
            cards: service.cards,
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                const Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      ServiceCardDescription(),
                    ],
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButtonWidget.startService(
                      onPressed: () async {
                        if (CommonProperties.isLoggedIn) {
                          if (CommonProperties.selectedDelegator != null) {
                            Navigator.of(context).pushNamed(
                                RouteName.postersDetailsPage,
                                arguments: bloc);
                          } else {
                            await BottomSheetDialog.showDraggableSheet(
                              context,
                              isFullHeight: false,
                              dialogKeyName:
                                  DialogName.notAuthorizedIndivisualDialog,
                              currentRouteName: RouteName.postersStartService,
                              child: NotAuthorizedIndivisualDialog(),
                            );
                          }
                        } else {
                          showDialog(
                              context: context,
                              builder: (ctx) => NeedLoginDialog(
                                      onSuccessLogin: (bool? isSuccess) async {
                                    if (isSuccess ?? false) {
                                      if (CommonProperties.selectedDelegator !=
                                          null) {
                                        Navigator.of(context).pushNamed(
                                            RouteName.postersDetailsPage,
                                            arguments: bloc);
                                      } else {
                                        await BottomSheetDialog
                                            .showDraggableSheet(
                                          context,
                                          isFullHeight: false,
                                          dialogKeyName: DialogName
                                              .notAuthorizedIndivisualDialog,
                                          currentRouteName:
                                              RouteName.postersStartService,
                                          child:
                                              NotAuthorizedIndivisualDialog(),
                                        );
                                      }
                                    }
                                  }));
                        }
                      },
                    ),
                  ),
                )
                /*SafeArea(
                      top: false,
                      child: ServiceWarningWidget(
                        warning: service.warning ?? "",
                        onPress: () async {
                          context
                              .read<PostersStartServiceBloc>()
                              .add(const ValidateBeforeApplyEvent());
                        },
                      ),
                    )*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}
