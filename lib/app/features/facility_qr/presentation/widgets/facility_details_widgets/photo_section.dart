import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:flutter/material.dart';

import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../../core/view_models/facility_details_view_model.dart';

class PhotoSection extends StatelessWidget {
  PhotoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = locator<FacilityQRDetailsViewModel>();

    return Column(
      children: [
        CustomVerticalSpace(height: 32),
        SizedBox(
          height: 190,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: model.entityPhotos.length,
              itemBuilder: (ctx, index) {
                return PhotoWidget(
                  title: model.entityPhotos[index].typeName ?? "",
                  img: model.entityPhotos[index].url[0],
                  onPress: () {
                    NavigationService.navigatorKey.currentState!
                        .pushNamed(RouteName.qrPhotosRoute);
                  },
                );
              }),
        ),
      ],
    );
  }
}

class PhotoWidget extends StatelessWidget {
  final String img;
  final String title;
  final Function onPress;

  const PhotoWidget(
      {Key? key, required this.title, required this.img, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        width: 120,
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Stack(
          children: [
            Container(
              foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.73),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Container(
                  decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    img,
                    headers: {
                      'Authorization':
                          'Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}'
                    },
                  ), //new ExactAssetImage('assets/images/' + img),
                  fit: BoxFit.cover,
                ),
              )),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsetsDirectional.only(bottom: 8, start: 8),
                child: CustomTextWidget(
                  title,
                  fontColor: Colors.white,
                  fontSize: 16,
                  fontWeight: AppFontWeight.medium,
                  textAlign: TextAlign.start,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
