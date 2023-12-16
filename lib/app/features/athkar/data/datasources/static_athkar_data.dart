import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/athkar/domain/entities/athkar_category.dart';
import 'package:balady_plus/app/features/athkar/domain/entities/athkar_entity.dart';

class StaticAthkarData {
  static final List<AthkarCategory> athkarCategories = [
    AthkarCategory(
        id: 1,
        name: 'اذكار الصباح',
        // athkarEntities: morningAthkarEntites,
        icon: IconPath.morningAthkarIcon),
    AthkarCategory(
        id: 2,
        name: 'اذكار النوم',
        //  athkarEntities: sleepingAthkarEntites,
        icon: IconPath.sleepingAthkarIcon),
    AthkarCategory(
        id: 3,
        name: 'اذكار المساء',
        //  athkarEntities: nightAthkarEntites,
        icon: IconPath.eveningAthkarIcon),
    AthkarCategory(
        id: 4,
        name: 'اذكار بعد الصلاة',
        // athkarEntities: afterPrayerAthkarEntites,
        icon: IconPath.afterPrayerIcon),
    AthkarCategory(
        id: 5,
        name: 'التسابيح',
        // athkarEntities: praisesAthkarEntities,
        icon: IconPath.praisesIcon),
    AthkarCategory(
        id: 6,
        name: 'اذكار الاستيقاظ من النوم',
        //  athkarEntities: wakeUpAthkarEntities,
        icon: IconPath.wakeUp),
    AthkarCategory(
        id: 7,
        name: 'اذكار الصلاة',
        //  athkarEntities: prayerAthkarEntities,
        icon: IconPath.pray),
    AthkarCategory(
        id: 8,
        name: 'جوامع الدعاء',
        //  athkarEntities: allAthkarEntities,
        icon: IconPath.handPrayer),
  ];
}
