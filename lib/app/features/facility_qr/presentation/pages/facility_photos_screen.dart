/*import 'package:balady_plus/app/core/core_exports.dart'
    show Constants, CustomAppBar, DrawLineWidget, Helpers, RoutesNames;
import 'package:balady_plus/shared/core/services/services_exports.dart'
    show NavigationService;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../facility_qr_exports.dart';

class FacilityPhotosScreen extends StatefulWidget {
  const FacilityPhotosScreen({Key? key}) : super(key: key);

  @override
  _FacilityPhotosScreen createState() => _FacilityPhotosScreen();
}

class _FacilityPhotosScreen extends State<FacilityPhotosScreen> {
  List<String> img = [
    "https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png",
    "https://www.linuxadictos.com/wp-content/uploads/Flutter.png",
    "https://purecode.sa/wp-content/uploads/flutter.png",
    "https://rokkey.com/static/a8e9fa7d012074a24f6057b1dbb47c4b/b4f03/fluttercover.jpg",
    "https://www.xda-developers.com/files/2018/02/Flutter-Framework-Feature-Image-Background-Colour.png",
    "https://dev-yakuza.posstree.com/assets/images/category/flutter/2021/drawer/drawer.jpg",
    "http://via.placeholder.com/350x150",
    "https://storage.googleapis.com/cms-storage-bucket/a667e994fc2f3e85de36.png",
    "http://via.placeholder.com/350x150"
  ];
  bool isScroll = false;
  final ScrollController _scrollController = ScrollController();

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
    return Scaffold(
      appBar: CustomAppBar(
        title: Helpers.translatingWord("photos"),
        withCloseImg: true,
      ),
      body: Container(
        margin: const EdgeInsetsDirectional.only(start: 16, top: 14),
        child: Column(
          children: [
            // horizontal scroll view for photo categories
            PhotoCategories(isScroll),
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
                    children: List<Widget>.generate(img.length, (index) {
                      return StaggeredGridTile.fit(
                        child: GridPhotoWidget(img[index]),
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

  const PhotoCategories(this.isScroll, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> title = ["كل الصور", "الصور الداخلية", "الصور الخارجية"];
    List<String> img = [
      "https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png",
      "https://www.linuxadictos.com/wp-content/uploads/Flutter.png",
      "https://purecode.sa/wp-content/uploads/flutter.png",
    ];
    // ignore: unused_local_variable
    int currentImageListIndex = 0;
    return AnimatedContainer(
      height: isScroll ? 64 : 190,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          // itemCount: model.entityPhotos.length,
          itemCount: img.length,
          itemBuilder: (ctx, index) {
            return PhotoWidget(
              title: title[index],
              img: img[index],
              // title: model.entityPhotos[index].typeName,
              // img: model.entityPhotos[index].url[0],
              onPress: () {
                currentImageListIndex = index;
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
        NavigationService.navigatorKey.currentState!
            .pushNamed(RoutesNames.photoViewRoute, arguments: imgUrl);
      },
      child: Image.network(
        imgUrl,
        // headers: {
        //   "Authorization": "Bearer ${locator<AuthService>().apigeeToken}"
        // },
        // width: MediaQuery.of(context).size.width / 2.3,
        width: 150,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
*/