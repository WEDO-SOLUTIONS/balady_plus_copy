import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../../facility_qr_exports.dart';

class FacilityPhotosScreen extends StatefulWidget {
  const FacilityPhotosScreen({Key? key}) : super(key: key);

  @override
  _FacilityPhotosScreen createState() => _FacilityPhotosScreen();
}

class _FacilityPhotosScreen extends State<FacilityPhotosScreen> {
  bool isScroll = false;
  final ScrollController _scrollController = ScrollController();
  int currentImageListIndex = 0;

  // final model = locator<EntityDetailsViewModel>();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == 0) {
        setState(() {
          isScroll = false;
        });
      } else {
        setState(() {
          isScroll = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = locator<FacilityQRDetailsViewModel>();

    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: ("photos").tr(),
      ),
      body: Container(
        margin: const EdgeInsetsDirectional.only(start: 16, top: 14),
        child: Column(
          children: [
            // horizontal scroll view for photo categories
            PhotoCategories(isScroll, (int index) {
              currentImageListIndex = index;
              setState(() {});
            }),
            Container(
              margin: const EdgeInsetsDirectional.only(end: 16),
              child: const DrawLineWidget(
                verticalMargin: Constants.mediumPadding,
              ),
            ),
            //Grid view for photos
            Expanded(
              child: Container(
                margin: const EdgeInsetsDirectional.only(end: 16),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: StaggeredGrid.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: List<Widget>.generate(
                        model.entityPhotos[currentImageListIndex].url.length,
                        (index) {
                      return StaggeredGridTile.fit(
                        child: GridPhotoWidget(model
                            .entityPhotos[currentImageListIndex].url[index]),
                        crossAxisCellCount: 2,
                      );
                    }),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PhotoCategories extends StatelessWidget {
  final bool isScroll;
  final Function onSelect;

  const PhotoCategories(this.isScroll, this.onSelect, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = locator<FacilityQRDetailsViewModel>();

    // ignore: unused_local_variable
    int currentImageListIndex = 0;
    return AnimatedContainer(
      height: isScroll ? 64 : 190,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: model.entityPhotos.length,
          itemBuilder: (ctx, index) {
            return PhotoWidget(
              title: model.entityPhotos[index].typeName ?? "",
              img: model.entityPhotos[index].url[0],
              // title: model.entityPhotos[index].typeName,
              // img: model.entityPhotos[index].url[0],
              onPress: () {
                currentImageListIndex = index;
                onSelect(currentImageListIndex);
              },
            );
          }),
    );
  }
}

class GridPhotoWidget extends StatelessWidget {
  final String imgUrl;

  const GridPhotoWidget(this.imgUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //  NavigationService.navigatorKey.currentState!
        //     .pushNamed(RouteName.photoViewRoute, arguments: imgUrl);
      },
      child: Image.network(
        imgUrl,
        headers: {
          'Authorization':
              'Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}'
        },
        // width: MediaQuery.of(context).size.width / 2.3,
        width: 150,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
