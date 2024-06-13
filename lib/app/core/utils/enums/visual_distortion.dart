import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';

enum VisualDistortion {
  distortedWritings(
    cardImg: ImagePath.distortedWritings,
    label: "distortedWritings",
    badAppearanceImg: ImagePath.buildingFacadesBad,
    badAppearanceDesc: "distortedWritings_badAppearanceDesc",
    badAppearanceDesc2: "distortedWritings_badAppearanceDes2",
    goodAppearanceImg: ImagePath.buildingFacadesGood,
    goodAppearanceDesc: "distortedWritings_goodAppearanceDesc",
    goodAppearanceDesc2: "distortedWritings_goodAppearanceDesc2",
  ),
  umbrellas(
    cardImg: ImagePath.umbrellas,
    label: "umbrellas",
    badAppearanceImg: ImagePath.buildingFacadesBad,
    badAppearanceDesc: "umbrellas_badAppearanceDesc",
    badAppearanceDesc2: "umbrellas_badAppearanceDesc2",
    goodAppearanceImg: ImagePath.buildingFacadesGood,
    goodAppearanceDesc: "umbrellas_goodAppearanceDesc",
    goodAppearanceDesc2: "umbrellas_goodAppearanceDesc2",
  ),
  abandonedBuildings(
    cardImg: ImagePath.abandonedBuildings,
    label: "abandonedBuildings",
    badAppearanceImg: ImagePath.buildingFacadesBad,
    badAppearanceDesc: "abandonedBuildings_badAppearanceDesc1",
    badAppearanceDesc2: "abandonedBuildings_badAppearanceDesc2",
    goodAppearanceImg: ImagePath.buildingFacadesGood,
    goodAppearanceDesc: "abandonedBuildings_goodAppearanceDesc",
    goodAppearanceDesc2: "abandonedBuildings_goodAppearanceDesc2",
  ),
  coveringPorches(
    cardImg: ImagePath.coveringPorches,
    label: "coveringPorches",
    badAppearanceImg: ImagePath.buildingFacadesBad,
    badAppearanceDesc: "coveringPorches_badAppearanceDesc",
    badAppearanceDesc2: "coveringPorches_badAppearanceDesc2",
    goodAppearanceImg: ImagePath.buildingFacadesGood,
    goodAppearanceDesc: "coveringPorches_goodAppearanceDesc",
    goodAppearanceDesc2: "coveringPorches_goodAppearanceDesc2",
  ),
  buildingFacades(
    cardImg: ImagePath.buildingFacades,
    label: "buildingFacades",
    badAppearanceImg: ImagePath.buildingFacadesBad,
    badAppearanceDesc: "buildingFacades_badAppearanceDesc",
    badAppearanceDesc2: "buildingFacades_badAppearanceDesc2",
    goodAppearanceImg: ImagePath.buildingFacadesGood,
    goodAppearanceDesc: "buildingFacades_goodAppearanceDesc",
    goodAppearanceDesc2: "buildingFacades_goodAppearanceDesc2",
  );

  const VisualDistortion({
    required this.cardImg,
    required this.label,
    required this.badAppearanceImg,
    required this.badAppearanceDesc,
    required this.badAppearanceDesc2,
    required this.goodAppearanceImg,
    required this.goodAppearanceDesc,
    required this.goodAppearanceDesc2,
  });
  final String cardImg;
  final String label;
  final String badAppearanceImg;
  final String badAppearanceDesc;
  final String badAppearanceDesc2;
  final String goodAppearanceImg;
  final String goodAppearanceDesc;
  final String goodAppearanceDesc2;
}
