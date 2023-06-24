import 'package:flutter/material.dart';
/*
class PhotoSection extends StatelessWidget {
  final List<String> title = ["كل الصور", "الصور الداخلية", "الصور الخارجية"];
  final String coverPhoto = "http://via.placeholder.com/350x150";

  PhotoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSectionHeaderWithImg(
          title: Helpers.translatingWord("photos"),
          desc: "",
          img: "photo@3x.png",
        ),
        SizedBox(
          height: 190,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: title.length,
              itemBuilder: (ctx, index) {
                return PhotoWidget(
                  title: title[index],
                  img: coverPhoto,
                  onPress: () {
                    NavigationService.navigatorKey.currentState!
                        .pushNamed(RoutesNames.facilityPhotosRoute);
                  },
                );
              }),
        ),
        const DrawLineWidget(
          verticalMargin: Constants.semiMediumPadding,
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
                      // "Authorization":
                      // "Bearer ${locator<AuthService>().apigeeToken}"
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
                  fontWeight: FONT_WEIGHT.medium,
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
*/