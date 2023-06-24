import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/facility_qr/presentation/core/view_models/facility_details_view_model.dart';
import 'package:flutter/material.dart';
import 'dart:async' show StreamController;

import 'package:balady_plus/app/features/facility_qr/facility_qr_exports.dart'
    show
        FacilityHeaderWidget,
        FeaturesWidget,
        RatingLine,
        QRLabelTextWidget,
        WorkingHourDetails;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/utils/map_utils.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';

import '../../../_shared_feature_/shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomNetworkImageWidget,
        CustomSvgIconWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        DrawLineWidget,
        LabelIconComponent,
        LabelIconSubtitleComponent;

class FacilityScreen extends StatefulWidget {
  const FacilityScreen({Key? key}) : super(key: key);

  @override
  _FacilityScreenState createState() => _FacilityScreenState();
}

class _FacilityScreenState extends State<FacilityScreen> {
  late StreamController<Map<String, double>> _headerStreamController;

  late Map<String, double> _appBarAndCardInfo;

  // cover img
  late double _maxCoverImageHeight;
  late double _minCoverImageHeight;

  // app bar
  late double _maxAppBarHeight;
  late double _minAppBarHeight;

  // threshold
  late double _maxThreshold;
  late double _minThreshold;

  // card
  late double _maxCardHeight;
  late double _minCardHeight;
  late double _currentCardHeight;

  // tween
  late double _maxHeaderBodyTweenSpace;
  late double _minHeaderBodyTweenSpace;

  //space ratio
  late double _divisionHeaderHeightTweenSpaceRatio;

  late ScrollController _scrollController;

// View Model
  final model = locator<FacilityQRDetailsViewModel>();

  @override
  void initState() {
    super.initState();

    _headerStreamController = StreamController<Map<String, double>>();

    _maxCoverImageHeight = 200.0;
    _minCoverImageHeight = 120.0;

    _maxAppBarHeight = 280;
    _minAppBarHeight = 150;

    _maxThreshold = _maxCoverImageHeight - _minCoverImageHeight;
    _minThreshold = 0.0;

    _maxCardHeight = 129.0;
    _minCardHeight = 63.0;
    _currentCardHeight = _maxCardHeight;

    _maxHeaderBodyTweenSpace = _maxCardHeight;
    _minHeaderBodyTweenSpace = _minCardHeight;

    _appBarAndCardInfo = {
      Constants.appBarAnimationKey: _maxCoverImageHeight,
      Constants.cardScaleAnimationKey: 1,
      Constants.headerBodyTweenSpaceAnimationKey: _maxHeaderBodyTweenSpace,
    };

    _divisionHeaderHeightTweenSpaceRatio =
        (_maxAppBarHeight - _minAppBarHeight) / _maxHeaderBodyTweenSpace;

    _scrollController = ScrollController();
    _scrollController.addListener(
      () => _scrollListener(_scrollController.position.pixels),
    );

    //MM  Helpers.sendEventToAnalytics(AppEvents.QR_Details);
  }

  @override
  void dispose() {
    _headerStreamController.close();
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener(double pixels) {
    if (pixels > _maxThreshold) {
      _currentCardHeight = _minCardHeight;
      _appBarAndCardInfo[Constants.appBarAnimationKey] = _minCoverImageHeight;
      _appBarAndCardInfo[Constants.headerBodyTweenSpaceAnimationKey] =
          _minHeaderBodyTweenSpace;
      _headerStreamController.sink.add(_appBarAndCardInfo);
    } else if (pixels <= _minThreshold) {
      _currentCardHeight = _maxCardHeight;
      _appBarAndCardInfo[Constants.appBarAnimationKey] = _maxCoverImageHeight;
      _appBarAndCardInfo[Constants.headerBodyTweenSpaceAnimationKey] =
          _maxHeaderBodyTweenSpace;
      _headerStreamController.sink.add(_appBarAndCardInfo);
    } else if (pixels > _minThreshold && pixels <= _maxThreshold) {
      // to make card change Size relative to appbar height
      if (_maxCardHeight - (pixels / _divisionHeaderHeightTweenSpaceRatio) <
          _minCardHeight) {
        _currentCardHeight = _minCardHeight;
      } else {
        _currentCardHeight =
            _maxCardHeight - (pixels / _divisionHeaderHeightTweenSpaceRatio);
      }
      final currentHeaderBodyTweenSpace = _maxHeaderBodyTweenSpace -
          (pixels / _divisionHeaderHeightTweenSpaceRatio);
      _appBarAndCardInfo[Constants.appBarAnimationKey] =
          _maxCoverImageHeight - pixels;
      _appBarAndCardInfo[Constants.headerBodyTweenSpaceAnimationKey] =
          currentHeaderBodyTweenSpace;
      _headerStreamController.sink.add(_appBarAndCardInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<FacilityQRDetailsViewModel>(
        onModelReady: (mo) {},
        builder: (context, model, child) {
          return Scaffold(
              backgroundColor: AppColor.white2,
              body: Stack(
                children: [
                  CustomNetworkImageWidget(
                    model.getCoverPhotoUrl(),
                    imageHeight: 200,
                    imageWidth: double.infinity,
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(
                        top: MediaQuery.of(context).padding.top,
                        start: 12,
                        end: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Image.asset(IconPath.qrGreyCloseIcon),
                        ),
                        // remove share icon temp
                        /*IconButton(
                onPressed: () {
              if (shareUrl.isNotEmpty) {
                Share.share(shareUrl);
              }
                },
                icon: Image.asset(Constants.imgPath + 'share_circle@3x.png'),
              ),*/
                      ],
                    ),
                  ),

                  // body
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin: EdgeInsets.only(top: 180),
                    decoration: BoxDecoration(
                      color: AppColor.scaffoldBackground,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Facility Info Section
                          FacilityInfoSection(), //MM
                          // Facility Contact Info
                          const FacilityContactsInfo(), //MM
                          //Features Section
                          const FeaturesSection(),
                          // Map Section
                          MapSection(), //MM
                          //Evaluation Section
                          EvaluationSection(),
                          //Photo Section
                          //PhotoSection(),

                          // Submit Incident Button
                          const SubmitIncidentSection(),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
        });
  }
} //MM

class FacilityInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FacilityQRDetailsViewModel viewModel =
        locator<FacilityQRDetailsViewModel>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QRLabelTextWidget(text: ("تفاصيل العمل والتواصل").tr()),
        const CustomVerticalSpace(height: 16),
        if (viewModel.facilityRespoonse != null &&
            viewModel.facilityRespoonse!.data!.result!.workTimes != null)
          WorkingHourDetails(
            openNow: viewModel.isOpenNow,
            todayWorkingHours: viewModel.getTodayWorkingHours(),
            workingHours: viewModel.facilityRespoonse!.data!.result!.workTimes!,
          ),
        /* CustomSectionSubHeaderAndDescWithImg(
          title: ('rating_tours').tr(),
          titleImg: "qr_rating_star@3x.png",
          desc: viewModel.getFacilityClassification(),
          descImg: viewModel.getFacilityClassificationImg(),
        ),*/
        const CustomVerticalSpace(height: 16),
        LabelIconSubtitleComponent(
          text: ('rating_tours').tr(),
          icon: IconPath.qrWebIcon,
          subtitle: viewModel.getFacilityClassification(),
          onPress: () {
            viewModel.launchURL(viewModel.getWebUrl());
          },
        ),
        if (viewModel.getWebUrl().isNotEmpty) ...[
          const CustomVerticalSpace(height: 16),
          LabelIconSubtitleComponent(
            text: ('website').tr(),
            icon: IconPath.qrWebIcon,
            subtitle: viewModel.getWebUrl(),
            onPress: () {
              viewModel.launchURL(viewModel.getWebUrl());
            },
          )
        ],
        if (viewModel.getEnterpriseUniqueCode().isNotEmpty) ...[
          const CustomVerticalSpace(height: 16),
          LabelIconSubtitleComponent(
            text: ('contact_number').tr(),
            icon: IconPath.qrWebIcon,
            subtitle: viewModel.getEnterpriseUniqueCode(),
            onPress: () {
              viewModel.launchURL(viewModel.getWebUrl());
            },
          )
        ],
        //  QRLabelTextWidget(text: ("تفاصيل الموقع").tr()),
        //  QRLabelTextWidget(text: ("تفاصيل التقييم").tr()),

        /*
      
     
        CustomSectionSubHeaderAndDescWithImg(
          title: ('rating_tours').tr(),
          titleImg: "qr_rating_star@3x.png",
          desc: viewModel.getFacilityClassification(),
          descImg: viewModel.getFacilityClassificationImg(),
        ),
    
     */
        const CustomVerticalSpace(height: 16),
      ],
    );
  }
}

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FacilityQRDetailsViewModel model =
        locator<FacilityQRDetailsViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QRLabelTextWidget(text: ("الخدمات المقدمة").tr()),
        const CustomVerticalSpace(height: 16),
        Wrap(
          direction: Axis.horizontal,
          spacing: 12,
          children: [
            FeaturesWidget(
              title: ("qr_parking_label").tr(),
              available: model.hasParking(),
            ),
            FeaturesWidget(
              title: ("qr_vehicle_parkingn_label").tr(),
              available: model.hasVehicleParking(),
            ),
            FeaturesWidget(
              title: ("qr_delivery_label").tr(),
              available: model.hasDelivery(),
            ),
            FeaturesWidget(
              title: ("qr_disable_persons_label").tr(),
              available: model.serveDisabledPersons(),
            ),
          ],
        ),
        const DrawLineWidget(
          verticalMargin: Constants.semiMediumPadding,
        ),
      ],
    );
  }
}

class EvaluationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FacilityQRDetailsViewModel viewModel =
        locator<FacilityQRDetailsViewModel>();
//MM
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      /* CustomSectionHeaderWithImg(
        title: ('ratings').tr(),
        desc: ("qr_rating_text")
            .tr()
            .replaceFirst("{}", viewModel.getFacilityAvrageRating().toString())
            .replaceFirst(
                "[]", viewModel.getFacilityTotalRatingCount().toString()),
        img: "rate@3x.png",
      ),*/
      QRLabelTextWidget(text: ("تفاصيل التقييم").tr()),

      /*  RateAndReviewWidgetWithoutDivider(
          rate: viewModel.getFacilityAvrageRating(),
          review: viewModel.getFacilityTotalRatingCount()),
          */
      const CustomVerticalSpace(height: 16),
      LabelIconSubtitleComponent(
        text: ('التقييم').tr(),
        icon: IconPath.qrRatingIcon,
        subWidget: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List<Widget>.from(viewModel.ratingItemAverages().map((e) {
                return RatingLine(
                  name: e.name ?? "",
                  rating: e.getAverage(),
                );
              }).toList())
            ],
          ),
        ),
      ),
      const CustomVerticalSpace(height: 27),
      EnhancedCustomElevatedButtonWidget(
        btnPressed: () {
          //  NavigationService.navigatorKey.currentState!
          //      .pushNamed(RouteName.facilityRatingRoute); //MM
        },
        btnText: ("evaluate_facility").tr(),
        btnTextSize: 16,
        btnTextWeight: AppFontWeight.medium,
        btnHeight: 56,
        btnTextColor: AppColor.darkTurquoise,
        btnBorderColor: AppColor.darkTurquoise,
        btnColor: AppColor.white,
      ),
    ]);
  }
}

class MapSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FacilityQRDetailsViewModel viewModel =
        locator<FacilityQRDetailsViewModel>();

    return viewModel.getMapLocation() != null
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            QRLabelTextWidget(text: ("تفاصيل الموقع").tr()),
            CustomVerticalSpace(height: 16),
            LabelIconSubtitleComponent(
              text: ("العنوان").tr(),
              icon: IconPath.qrLocationIcon,
              subtitle: viewModel.getCityAndStreet(),
            ),
            CustomVerticalSpace(height: 16),
            LabelIconSubtitleComponent(
              text: ("ملخص الموقع").tr(),
              icon: IconPath.qrLocationIcon,
              subWidget: Container(
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 160,
                      child: GoogleMap(
                          markers: {
                            /* Marker(
                                visible: MapUtils.locationMarker != null,
                                markerId: const MarkerId("storeLocation"),
                                icon: MapUtils.locationMarker!,
                                position: viewModel.getMapLocation()!)*/
                          },
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                              target: viewModel.getMapLocation()!, zoom: 13)),
                    ),
                    TextButton(
                      onPressed: () {
                        if (viewModel.getMapLocation() != null) {
                          viewModel.launchMapsUrl(viewModel.getMapLocation()!);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget(
                            ("facility_location_with_google").tr(),
                            fontSize: 17,
                            fontWeight: AppFontWeight.medium,
                            fontColor: AppColor.black,
                            textAlign: TextAlign.start,
                          ),
                          CustomSvgIconWidget(IconPath.qrOpenLinkIcon)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ])
        : Container();
  }
}

class FacilityContactsInfo extends StatelessWidget {
  const FacilityContactsInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FacilityQRDetailsViewModel viewModel =
        locator<FacilityQRDetailsViewModel>();
    if ((viewModel.twitterContact().isNotEmpty) ||
        viewModel.snapchatContact().isNotEmpty ||
        viewModel.instegramContact().isNotEmpty ||
        viewModel.whatsUpContact().isNotEmpty ||
        viewModel.facebookContact().isNotEmpty) {
      return LabelIconSubtitleComponent(
          text: ('التواصل الإجتماعي').tr(),
          icon: IconPath.qrWebIcon,
          subWidget: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (viewModel.twitterContact().isNotEmpty)
                CustomIconButtonWidget(
                  icon: IconPath.qrTwitterIcon, //MM
                  onPressed: () {
                    viewModel.launchURL(viewModel.twitterContact());
                  },
                  btnHeight: 42,
                  btnWidth: 42,
                ),
              if (viewModel.snapchatContact().isNotEmpty)
                CustomIconButtonWidget(
                  icon: IconPath.qrSnapChatIcon,
                  onPressed: () {
                    viewModel.launchURL(viewModel.snapchatContact());
                  },
                  btnHeight: 42,
                  btnWidth: 42,
                ),
              if (viewModel.instegramContact().isNotEmpty)
                CustomIconButtonWidget(
                  icon: IconPath.qrInstagramIcon,
                  onPressed: () {
                    viewModel.launchURL(viewModel.instegramContact());
                  },
                  btnHeight: 42,
                  btnWidth: 42,
                ),
              if (viewModel.whatsUpContact().isNotEmpty)
                CustomIconButtonWidget(
                  icon: IconPath.qrWhatsupIcon,
                  onPressed: () {
                    String mobileNumber = viewModel.whatsUpContact();
                    if (mobileNumber.isNotEmpty) {
                      mobileNumber = "http://wa.me/$mobileNumber";
                      viewModel.launchURL(mobileNumber);
                    }
                  },
                  btnHeight: 42,
                  btnWidth: 42,
                ),
              if (viewModel.facebookContact().isNotEmpty)
                CustomIconButtonWidget(
                  icon: IconPath.qrFaceBookIcon,
                  onPressed: () {
                    viewModel.launchURL(viewModel.facebookContact());
                  },
                  btnHeight: 42,
                  btnWidth: 42,
                ),
            ],
          ));
    }
    return const SizedBox();
  }
}

class SubmitIncidentSection extends StatelessWidget {
  const SubmitIncidentSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FacilityQRDetailsViewModel viewModel =
        locator<FacilityQRDetailsViewModel>();

    return Column(children: [
      const CustomVerticalSpace(height: 32),
      EnhancedCustomElevatedButtonWidget(
        btnPressed: () {
          /* viewModel.navigateToCreateIncident(
              fromScreen: PAGE_TYPE.qrDetailsScreen);*/ //MM
        },
        btnText: ("submit_incident_facility").tr(),
        btnTextSize: 16,
        btnTextWeight: AppFontWeight.medium,
        btnHeight: 56,
        btnTextColor: AppColor.redBrown,
        btnBorderColor: AppColor.redBrown,
        btnColor: AppColor.white,
      ),
      const CustomVerticalSpace(height: 32),
    ]);
  }
}
