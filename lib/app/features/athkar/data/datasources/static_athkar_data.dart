import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/athkar/domain/entities/athkar_category.dart';
import 'package:balady_plus/app/features/athkar/domain/entities/athkar_entity.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class StaticAthkarData {
  static final List<AthkarCategory> athkarCategories = [
    AthkarCategory(
        id: 1,
        name: 'Morning_Remembrances',
        // athkarEntities: morningAthkarEntites,
        icon: IconPath.morningAthkarIcon),
    AthkarCategory(
        id: 2,
        name: "BedtimeـRemembrances",
        //  athkarEntities: sleepingAthkarEntites,
        icon: IconPath.sleepingAthkarIcon),
    AthkarCategory(
        id: 3,
        name: "EveningـRemembrances",
        //  athkarEntities: nightAthkarEntites,
        icon: IconPath.eveningAthkarIcon),
    AthkarCategory(
        id: 4,
        name: "Post-PrayerـRemembrances",
        // athkarEntities: afterPrayerAthkarEntites,
        icon: IconPath.afterPrayerIcon),
    AthkarCategory(
        id: 5,
        name: "Praises",
        // athkarEntities: praisesAthkarEntities,
        icon: IconPath.praisesIcon),
    AthkarCategory(
        id: 6,
        name: "Remembrance_of_waking_up",
        //  athkarEntities: wakeUpAthkarEntities,
        icon: IconPath.wakeUp),
    AthkarCategory(
        id: 7,
        name: "Prayer_Remembrances",
        //  athkarEntities: prayerAthkarEntities,
        icon: IconPath.pray),
    AthkarCategory(
        id: 8,
        name: "Comprehensive_Supplications",
        //  athkarEntities: allAthkarEntities,
        icon: IconPath.handPrayer),
  ];
}
