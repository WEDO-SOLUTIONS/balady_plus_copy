import 'package:flutter/material.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/_features/poi_card/poi_card_view_model.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/shared/config/package_fonts.dart';

class PoiCardFooter extends StatelessWidget {
  final PoiModel data;
  final PoiCardViewModel viewModel;

  final void Function() onEntranceTap;

  const PoiCardFooter({
    super.key,
    required this.data,
    required this.viewModel,
    required this.onEntranceTap,
  });

  @override
  Widget build(BuildContext context) {
    final favData = viewModel.getIsFavourite(data);

    final routeTime = data.getBriefRouteDescription();

    final objectMessage = data.directoryObjectMessage;
    final hasEntrances = objectMessage?.entrances.isNotEmpty == true;
    final hasContacts = objectMessage?.contactInfos.isNotEmpty == true;
    final hasRouteTime = routeTime != null;
    final carIconFlex = (hasEntrances || hasContacts) && hasRouteTime ? 3 : 2;
    final isFav = favData != null;

    favItem({int flex = 1}) {
      return buildIconButton(
        flex: flex,
        assetName: isFav
            ? 'assets/icons/svg/ic_fav_solid.svg'
            : 'assets/icons/svg/ic_fav_poi.svg',
        onTap: () {
          if (favData == null) {
            final directoryObjectMessage = objectMessage;
            if (directoryObjectMessage != null) {
              viewModel.addToFavourites(directoryObjectMessage);
            }
          } else {
            viewModel.removeFromFavourite(favData);
          }
        },
        desc: (hasEntrances == false && hasContacts == false)
            ? Text(
                'المفضلة',
                style: PackageFonts.frutigerArabic(
                  color: colorPrimary.withOpacity(0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.start,
              )
            : const SizedBox.shrink(),
      );
    }

    carItem({int flex = 1}) => buildIconButton(
          flex: flex,
          colorIcon: hasRouteTime ? Colors.white : null,
          colorButton: hasRouteTime ? colorAccent : null,
          desc: hasRouteTime
              ? Text(
                  routeTime,
                  style: PackageFonts.frutigerArabic(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                )
              : null,
          assetName: 'assets/icons/svg/ic_car_poi.svg',
          onTap: () {
            if (objectMessage?.markerPosition != null) {
              RoutingRoutesRoute(
                finishLabel: objectMessage!.title,
                finishLatitude: objectMessage.markerPosition!.latitude,
                finishLongitude: objectMessage.markerPosition!.longitude,
                startLabel: 'My Location',
                startLatitude: null,
                startLongitude: null,
              ).pushReplacement(context);
            }
          },
        );

    entranceItem({int flex = 1}) => hasEntrances
        ? buildIconButton(
            flex: flex,
            assetName: 'assets/icons/svg/ic_entrance.svg',
            onTap: onEntranceTap,
          )
        : const SizedBox.shrink();

    shareItem({int flex = 1}) => buildIconButton(
          flex: flex,
          desc: (hasEntrances == false && hasContacts == false)
              ? Text(
                  'يشارك',
                  style: PackageFonts.frutigerArabic(
                    color: colorPrimary.withOpacity(0.5),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                )
              : const SizedBox.shrink(),
          assetName: 'assets/icons/svg/ic_share.svg',
          onTap: () => viewModel.share(objectMessage),
        );

    phoneItem({int flex = 1}) => hasContacts
        ? buildIconButton(
            flex: flex,
            assetName: 'assets/icons/svg/ic_phone_poi.svg',
            onTap: () => viewModel.callPhone(data: objectMessage),
          )
        : const SizedBox.shrink();

    final childrenRtl = (hasContacts == false && hasEntrances == false)
        ? [
            favItem(flex: 2),
            shareItem(flex: 2),
            carItem(flex: 3),
          ]
        : [
            shareItem(flex: 2),
            if (hasEntrances) entranceItem(flex: 2),
            if (hasContacts) phoneItem(flex: 2),
            favItem(flex: 2),
            carItem(flex: carIconFlex),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: childrenRtl,
          ),
        ),
      ),
    );
  }
}
