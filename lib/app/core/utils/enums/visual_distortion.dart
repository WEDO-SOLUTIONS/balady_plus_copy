import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';

enum VisualDistortion {
  distortedWritings(
    cardImg: ImagePath.distortedWritings,
    label: "الكتابات المشوهة للجدران والدهان",
    badAppearanceImg: ImagePath.buildingFacadesBad,
    badAppearanceDesc:
    "المباني المهجورة غير مكتملة الصيانة / أو التي لم تتم صيانتها بشكل جيد موضوعًا تعطي انطباعًا عامًا بالإهمال.",
    badAppearanceDesc2:
    "تشغل المباني المهجورة حيزًا كبيرًا في الأماكنالعامة الحيوية التي ربما تم استخدامها لأغراض أخرى، مما يسبب الشعور بالفوضى والازدحام.",
    goodAppearanceImg: ImagePath.buildingFacadesGood,
    goodAppearanceDesc:
    "يجب النظر في هدم المباني المهجورة أو تجديدها من خلال استخدامها لأغراض",
    goodAppearanceDesc2:
    "يجب النظر في هدم المباني المهجورة أو تجديدها من خلال استخدامها لأغراض أخرى وتجميلها",
  ),
  umbrellas(
    cardImg: ImagePath.umbrellas,
    label: "المظلات",
    badAppearanceImg: ImagePath.buildingFacadesBad,
    badAppearanceDesc:
    "المباني المهجورة غير مكتملة الصيانة / أو التي لم تتم صيانتها بشكل جيد موضوعًا تعطي انطباعًا عامًا بالإهمال.",
    badAppearanceDesc2:
    "تشغل المباني المهجورة حيزًا كبيرًا في الأماكنالعامة الحيوية التي ربما تم استخدامها لأغراض أخرى، مما يسبب الشعور بالفوضى والازدحام.",
    goodAppearanceImg: ImagePath.buildingFacadesGood,
    goodAppearanceDesc:
    "يجب النظر في هدم المباني المهجورة أو تجديدها من خلال استخدامها لأغراض",
    goodAppearanceDesc2:
    "يجب النظر في هدم المباني المهجورة أو تجديدها من خلال استخدامها لأغراض أخرى وتجميلها",
  ),
  abandonedBuildings(
    cardImg: ImagePath.abandonedBuildings,
    label: "المباني المهجورة",
    badAppearanceImg: ImagePath.buildingFacadesBad,
    badAppearanceDesc:
    "المباني المهجورة غير مكتملة الصيانة / أو التي لم تتم صيانتها بشكل جيد موضوعًا تعطي انطباعًا عامًا بالإهمال.",
    badAppearanceDesc2:
    "تشغل المباني المهجورة حيزًا كبيرًا في الأماكنالعامة الحيوية التي ربما تم استخدامها لأغراض أخرى، مما يسبب الشعور بالفوضى والازدحام.",
    goodAppearanceImg: ImagePath.buildingFacadesGood,
    goodAppearanceDesc:
    "يجب النظر في هدم المباني المهجورة أو تجديدها من خلال استخدامها لأغراض",
    goodAppearanceDesc2:
    "يجب النظر في هدم المباني المهجورة أو تجديدها من خلال استخدامها لأغراض أخرى وتجميلها",
  ),
  coveringPorches(
    cardImg: ImagePath.coveringPorches,
    label: "تغطية الشرفات",
    badAppearanceImg: ImagePath.buildingFacadesBad,
    badAppearanceDesc:
    "المباني المهجورة غير مكتملة الصيانة / أو التي لم تتم صيانتها بشكل جيد موضوعًا تعطي انطباعًا عامًا بالإهمال.",
    badAppearanceDesc2:
    "تشغل المباني المهجورة حيزًا كبيرًا في الأماكنالعامة الحيوية التي ربما تم استخدامها لأغراض أخرى، مما يسبب الشعور بالفوضى والازدحام.",
    goodAppearanceImg: ImagePath.buildingFacadesGood,
    goodAppearanceDesc:
    "يجب النظر في هدم المباني المهجورة أو تجديدها من خلال استخدامها لأغراض",
    goodAppearanceDesc2:
    "يجب النظر في هدم المباني المهجورة أو تجديدها من خلال استخدامها لأغراض أخرى وتجميلها",
  ),
  buildingFacades(
    cardImg: ImagePath.buildingFacades,
    label: "واجهات المباني",
    badAppearanceImg: ImagePath.buildingFacadesBad,
    badAppearanceDesc:
        "المباني المهجورة غير مكتملة الصيانة / أو التي لم تتم صيانتها بشكل جيد موضوعًا تعطي انطباعًا عامًا بالإهمال.",
    badAppearanceDesc2:
        "تشغل المباني المهجورة حيزًا كبيرًا في الأماكنالعامة الحيوية التي ربما تم استخدامها لأغراض أخرى، مما يسبب الشعور بالفوضى والازدحام.",
    goodAppearanceImg: ImagePath.buildingFacadesGood,
    goodAppearanceDesc:
        "يجب النظر في هدم المباني المهجورة أو تجديدها من خلال استخدامها لأغراض",
    goodAppearanceDesc2:
        "يجب النظر في هدم المباني المهجورة أو تجديدها من خلال استخدامها لأغراض أخرى وتجميلها",
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
