import 'package:balady_plus/app/features/_shared_feature_/balady_features/balady_exports.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/lifestyle_layers/domain/investment_sites.dart';
import 'package:mapness/_features/lifestyle_layers/domain/point_layers_data.dart';
import 'package:mapness/_features/lifestyle_layers/domain/white_lands.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_details.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mapness/_features/lifestyle_layers/domain/building_compliance_certificate.dart';

class LayersDetailsWidget extends ConsumerStatefulWidget {

  const LayersDetailsWidget({super.key, this.data});
  final PointLayersData? data;

  @override
  ConsumerState<LayersDetailsWidget> createState() => LayersDetailsState();
}

class LayersDetailsState extends ConsumerState<LayersDetailsWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ref.watch(layersDetailsProvider(widget.data!)).map(
                  data: (data) {
                    switch (data.value) {
                      case final WhiteLands? selectedPoint:
                        return Material(
                          color: Colors.transparent,
                          type: MaterialType.transparency,
                          child: WhiteLandMapCard(
                            municipality: selectedPoint?.MUNNAME,
                            streetName: selectedPoint?.STREETNAME,
                            parcelNo: selectedPoint?.PARCELCODE,
                            stageNo: selectedPoint?.PHASE,
                            onClose: () => context.pop(),
                          ),
                        );
                      case final InvestmentSites? selectedPoint:
                        return Material(
                          color: Colors.transparent,
                          type: MaterialType.transparency,
                          child: OpprtunityMapCard(
                            area: '${selectedPoint?.SITEAREA}',
                            description: selectedPoint?.description,
                            type: selectedPoint?.TYPE ?? '',
                            bidEndDate: selectedPoint?.BIDENDDATE,
                            dailyCost: '${selectedPoint?.DAILYLEASECOST}',
                            documentValue: '${selectedPoint?.DOCUMENTVALUE}',
                            id: selectedPoint?.ID,
                            opprtunityNumber: selectedPoint?.OPPORTUNITYNUMBER,
                            subMunicipality: selectedPoint?.SUBMUNICIPALITY_ID,
                            mainActivcity: selectedPoint?.MAIN_ACTIVITY_NAME,
                            onClose: () => context.pop(),
                          ),
                        );
                      case final BuildingComplianceCertificate? selectedPoint:
                        return Material(
                          color: Colors.transparent,
                          type: MaterialType.transparency,
                          child: ComplainceMapCard(
                            amana: selectedPoint?.AMANANAME,
                            targetBuildingType:
                                selectedPoint?.TARGETBUILDINGTYPE,
                            streetName: selectedPoint?.STREETNAME,
                            stageNo: selectedPoint?.STAGENO,
                            onClose: () => context.pop(),
                          ),
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                  error: (error) {
                    context.pop();
                    return buildShimmer();
                  },
                  loading: (_) => buildShimmer(),),
            ],
          ),
        ),
      );

  Widget buildShimmer() => Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            ),
          ),
        ),
      );
}
