import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../services/core/home_services_routes/home_services_route_names.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () {

           Navigator.pushNamedAndRemoveUntil(context, RouteName.Observer_Choose_Municipality, ModalRoute.withName( HomeServicesRouteName.dynamicCardsServicesScreen));

          },
        ),


      ),
      body: InAppWebView(
        initialSettings: InAppWebViewSettings(
          useHybridComposition: true,
          javaScriptEnabled: true,
          useShouldOverrideUrlLoading: true,
        ),
        shouldOverrideUrlLoading: (controller, action) async {
          return NavigationActionPolicy.ALLOW;
        },
        onWebViewCreated: (InAppWebViewController controller) {
          // _controller = controller;
        },
        initialUrlRequest: URLRequest(
            url: WebUri("https://stgacademyapi.momrah.gov.sa/call-back"),
            headers: {
              "Authorization" : CommonProperties.token,
              'Accept': 'application/json',
            }
        ),
        onLoadStart: (controller, Uri? url) {},
        onLoadStop: (controller, Uri? url) {},
        onLoadError: (controller, url, code, message) => print(message),
        onProgressChanged: (controller, int progress) {
          final percent = progress / 100;
        },
      ),
    );
  }
}
