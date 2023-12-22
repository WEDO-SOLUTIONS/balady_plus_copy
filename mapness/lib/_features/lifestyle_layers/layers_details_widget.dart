import 'package:balady_plus/app/features/_shared_feature_/balady_features/balady_exports.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/lifestyle_layers/domain/investment_sites.dart';
import 'package:mapness/_features/lifestyle_layers/domain/point_layers_data.dart';
import 'package:mapness/_features/lifestyle_layers/domain/white_lands.dart';
import 'package:mapness/shared/providers/app_language.dart';

import 'domain/building_compliance_certificate.dart';

class LayersDetailsWidget extends ConsumerStatefulWidget {
  final PointLayersData? data;

  const LayersDetailsWidget({super.key, this.data});

  @override
  ConsumerState<LayersDetailsWidget> createState() => LayersDetailsState();
}

class LayersDetailsState extends ConsumerState<LayersDetailsWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var selectedPoint = widget.data;
    // var selectedPoint = widget.data as InvestmentSites?;
    // var selectedPoint = widget.data as BuildingComplianceCertificate?;
    final language = ref.watch(appLanguageProvider);
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (selectedPoint is WhiteLands?)
                WhiteLandMapCard(
                  municipality: selectedPoint?.MUNNAME,
                  streetName: selectedPoint?.STREETNAME,
                  parcelNo: selectedPoint?.PARCELCODE,
                  stageNo: selectedPoint?.PHASE,
                  onClose: () => context.pop(),
                ),
              if (selectedPoint is InvestmentSites?)
                OpprtunityMapCard(
                  description: selectedPoint?.description,
                  type: selectedPoint?.type ?? '',
                  bidEndDate: selectedPoint?.BIDENDDATE,
                  dailyCost: '${selectedPoint?.DAILYLEASECOST}',
                  documentValue: '${selectedPoint?.DOCUMENTVALUE}',
                  id: selectedPoint?.ID,
                  opprtunityNumber: selectedPoint?.OPPORTUNITYNUMBER,
                  subMunicipality: selectedPoint?.SUBMUNICIPALITY_ID,
                  mainActivcity: selectedPoint?.MAIN_ACTIVITY_NAME,

                  ///???
                  // location: selectedPoint?.,
                  //   area: selectedPoint?.,
                  // isSeasonal: selectedPoint?.,
                  // isFree: selectedPoint?.,
                  onClose: () => context.pop(),
                ),
              if (selectedPoint is BuildingComplianceCertificate?)
                ComplainceMapCard(
                  amana: selectedPoint?.AMANANAME,
                  targetBuildingType: selectedPoint?.TARGETBUILDINGTYPE,
                  streetName: selectedPoint?.STREETNAME,
                  stageNo: selectedPoint?.STAGENO,
                  onClose: () => context.pop(),
                ),
            ],
          ),
        ),
      ),
    );

    // return DraggableScrollableSheet(
    //   controller: _draggableScrollableController,
    //   initialChildSize: .3,
    //   minChildSize: .15,
    //   maxChildSize: .6,
    //   snapSizes: const [.3, .6],
    //   snap: true,
    //   builder: (BuildContext context, ScrollController scrollController) {
    //     return Material(
    //       color: Colors.transparent,
    //       child: Directionality(
    //         textDirection: TextDirection.rtl,
    //         child: Container(
    //           padding: const EdgeInsets.all(16),
    //           decoration: const BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.only(
    //               topRight: Radius.circular(16.0),
    //               topLeft: Radius.circular(16.0),
    //             ),
    //           ),
    //           child: Stack(
    //             children: [
    //               CustomScrollView(
    //                 controller: scrollController,
    //                 primary: false,
    //                 physics: const ClampingScrollPhysics(),
    //                 slivers: [
    //                   SliverToBoxAdapter(
    //                     child: Column(children: [
    //                       Container(
    //                         height: 4,
    //                         width: 40,
    //                         decoration: const BoxDecoration(
    //                           color: Color(0xFFDDE4EE),
    //                           borderRadius:
    //                               BorderRadius.all(Radius.circular(24)),
    //                         ),
    //                       ),
    //                       const SizedBox(
    //                         height: 16,
    //                       ),
    //
    //
    //                       // WhiteLandMapCard(
    //                       //   municipality: selectedPoint?.MUNNAME,
    //                       //   subMunicipality: selectedPoint?.STREETNAME,
    //                       //   parcelNo: selectedPoint?.PARCELCODE,
    //                       //   stageNo: selectedPoint?.PHASE,
    //                       //   onClose: () => context.pop(),
    //                       // ),
    //                       const SizedBox(
    //                         height: 16,
    //                       ),
    //                     ]),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
