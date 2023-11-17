import 'package:flutter/material.dart';
import 'package:mapness/_features/map/providers/point_of_interest.dart';
import 'package:mapness/_features/poi_card/poi_card_view_model.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';

class PoiCardFooter extends StatelessWidget {
  final PoiModel data;
  final PoiCardViewModel viewModel;

  const PoiCardFooter({
    super.key,
    required this.data,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final isFavourite = viewModel.getIsFavourite(data);

    bool isRTL() => Directionality.of(context).index == 0;

    final favItem = buildIconButton(
      assetName: isFavourite != null
          ? 'assets/icons/svg/ic_fav_solid.svg'
          : 'assets/icons/svg/ic_fav_poi.svg',
      onTap: () {
        if (isFavourite == null) {
          viewModel.addToFavourites(data.directoryObjectMessage);
        }
      },
    );

    final carItem = buildIconButton(
      desc: data.getBriefRouteDescription(),
      assetName: 'assets/icons/svg/ic_car_poi.svg',
      onTap: () => viewModel.openMap(data.directoryObjectMessage),
    );

    final childrenRtl = [
      buildIconButton(
        assetName: 'assets/icons/svg/ic_share.svg',
        onTap: viewModel.share,
      ),
      buildIconButton(
        assetName: 'assets/icons/svg/ic_entrance.svg',
        onTap: viewModel.onEntranceTap,
      ),
      buildIconButton(
        assetName: 'assets/icons/svg/ic_phone_poi.svg',
        onTap: () => viewModel.callPhone(data: data.directoryObjectMessage),
      ),
      favItem,
      carItem,
    ];
    final childrenLtr = [
      carItem,
      favItem,
      buildIconButton(
        assetName: 'assets/icons/svg/ic_phone_poi.svg',
        onTap: () => viewModel.callPhone(data: data.directoryObjectMessage),
      ),
      buildIconButton(
        assetName: 'assets/icons/svg/ic_entrance.svg',
        onTap: viewModel.onEntranceTap,
      ),
      buildIconButton(
        assetName: 'assets/icons/svg/ic_share.svg',
        onTap: viewModel.share,
      ),
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: footerHeight,
          child: Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: isRTL() ? childrenRtl : childrenLtr,
          ),
        ),
      ),
    );
  }
}
