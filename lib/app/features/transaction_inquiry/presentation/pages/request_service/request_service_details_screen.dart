/*import 'package:balady_plus/app/core/core_exports.dart'
    show
        AppColors,
        CustomHeaderAndDesc,
        CustomSectionHeaderWithImg,
        Helpers,
        CustomCircularLoadingWidget,
        CRM_REQUEST_TYPE;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../customer_voice_exports.dart'
    show
        OrderSilverAppBar,
        AttachmentSection,
        RequestStatusCard,
        IncidentDetailsViewModel,
        RequestDetailsScreenArgs;

class RequestServiceDetailsScreen extends StatefulWidget {
  final RequestDetailsScreenArgs args;

  const RequestServiceDetailsScreen({Key? key, required this.args})
      : super(key: key);

  @override
  _RequestServiceDetailsScreen createState() => _RequestServiceDetailsScreen();
}

class _RequestServiceDetailsScreen extends State<RequestServiceDetailsScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => IncidentDetailsViewModel(arg: widget.args),
        builder: (context, child) {
          IncidentDetailsViewModel model =
              Provider.of<IncidentDetailsViewModel>(context);
          return Scaffold(
              backgroundColor: AppColor.white,
              appBar: null,
              body: Stack(
                children: <Widget>[
                  CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    slivers: <Widget>[
                      // app bar
                      OrderSilverAppBar(
                        title: model.getTitle(),
                        orderDate: model.getDate(),
                        orderId: model.getId(),
                      ),
                      // body
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: [
                                  RequestStatusCard(
                                    auditInformation:
                                        model.args.response.auditInformation!,
                                    municipalityName:
                                        model.args.item.municipalityName ?? "",
                                    type: CRM_REQUEST_TYPE.req,
                                  ),
                                  // order location
                                  const OrderLocation(),
                                  // incident info section
                                  const OrderDetailsSection(),
                                  // attachment view section
                                  if (model.files.isNotEmpty)
                                    AttachmentSection(
                                      files: model.files,
                                      isMSR: true,
                                    ),
                                  if (model.loadImages)
                                    const CustomCircularLoadingWidget()
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*    if (model.isLoading) CustomCircularLoadingWidget()*/
                ],
              ));
        });
  }
}

class OrderLocation extends StatelessWidget {
  const OrderLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IncidentDetailsViewModel model =
        Provider.of<IncidentDetailsViewModel>(context);
    return Column(
      children: [
        CustomSectionHeaderWithImg(
          title: Helpers.translatingWord('order_location'),
          img: "locationList@3x.png",
        ),
        CustomHeaderAndDesc(
          header: Helpers.translatingWord('order_address'),
          desc: model.args.response.locationInfo?.address,
          icon: const Icon(Icons.location_on, color: AppColor.greenLight),
          bottomMargin: 0,
          onPress: () => _launchMapsUrl(model.getLocationLatLng()),
        ),
      ],
    );
  }

  void _launchMapsUrl(LatLng? location) async {
    LatLng? _location = location;
    if (_location != null) {
      final url =
          'https://www.google.com/maps/search/?api=1&query=${_location.latitude},${_location.longitude}';

      await launch(url);
    }
  }
}

class OrderDetailsSection extends StatelessWidget {
  const OrderDetailsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IncidentDetailsViewModel model =
        Provider.of<IncidentDetailsViewModel>(context);
    return Column(
      children: [
        CustomSectionHeaderWithImg(
          title: Helpers.translatingWord(
              'customerVoiceLatestRequestsSectionGoToDetailsButtonWord'),
          img: "reportDetailsList@3x.png",
        ),
        CustomHeaderAndDesc(
          header: Helpers.translatingWord("lbl_main_category"),
          desc: model.args.item.mainClassificationName,
        ),
        CustomHeaderAndDesc(
          header: Helpers.translatingWord('lbl_sub_category'),
          desc: model.args.item.subClassificationName,
        ),
        CustomHeaderAndDesc(
          header: Helpers.translatingWord("lbl_specialty_classification_hint1"),
          desc: model.args.item.splClassificationName,
        ),
        Visibility(
          visible: model.getSPLDescription().isNotEmpty,
          child: CustomHeaderAndDesc(
            header: Helpers.translatingWord("spl_description"),
            desc: model.getSPLDescription(),
          ),
        ),
        CustomHeaderAndDesc(
          header: Helpers.translatingWord("description"),
          desc: model.args.response.incidentInformation?.issueDescription,
        ),
      ],
    );
  }
}
*/
