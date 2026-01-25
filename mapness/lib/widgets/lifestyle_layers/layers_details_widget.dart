import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/balady_exports.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/lifestyle_layers/models/building_compliance_certificate.dart';
import 'package:mapness/features/lifestyle_layers/models/investment_sites.dart';
import 'package:mapness/features/lifestyle_layers/models/point_layers_data.dart';
import 'package:mapness/features/lifestyle_layers/models/white_lands.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_details.dart';
import 'package:shimmer/shimmer.dart';

@RoutePage()
class LayersDetailsWidgetPage extends ConsumerStatefulWidget {
  const LayersDetailsWidgetPage({super.key, this.data});

  final PointLayersData? data;

  @override
  ConsumerState<LayersDetailsWidgetPage> createState() => LayersDetailsState();
}

class LayersDetailsState extends ConsumerState<LayersDetailsWidgetPage> {
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
                              municipality: selectedPoint?.munname,
                              streetName: selectedPoint?.streetName,
                              parcelNo: selectedPoint?.parcelCode,
                              stageNo: selectedPoint?.phase,
                              onClose: () => context.router.pop(),
                            ),
                          );
                        case final InvestmentSites? selectedPoint:
                          return Material(
                            color: Colors.transparent,
                            type: MaterialType.transparency,
                            child: OpportunityMapCard(
                              area: '${selectedPoint?.siteArea}',
                              description: selectedPoint?.description,
                              type: selectedPoint?.objectType ?? '',
                              bidEndDate: selectedPoint?.bidendDate,
                              dailyCost: '${selectedPoint?.dailyEaseCost}',
                              documentValue: '${selectedPoint?.documentValue}',
                              id: selectedPoint?.objectId,
                              opportunityNumber: selectedPoint?.opportunityNumber,
                              subMunicipality: selectedPoint?.subMunicipalityId,
                              mainActivity: selectedPoint?.mainActivityName,
                              onClose: () => context.router.pop(),
                            ),
                          );
                        case final BuildingComplianceCertificate? selectedPoint:
                          return Material(
                            color: Colors.transparent,
                            type: MaterialType.transparency,
                            child: ComplainceMapCard(
                              amana: selectedPoint?.amananme,
                              targetBuildingType: selectedPoint?.targetBuildingType,
                              streetName: selectedPoint?.streetName,
                              stageNo: selectedPoint?.stageno,
                              onClose: () => context.router.pop(),
                            ),
                          );
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                    error: (error) {
                      context.router.pop();
                      return buildShimmer();
                    },
                    loading: (_) => buildShimmer(),
                  ),
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
