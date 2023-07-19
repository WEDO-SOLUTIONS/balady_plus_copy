import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/athkar/domain/entities/athkar_category.dart';
import 'package:balady_plus/app/features/athkar/domain/entities/athkar_entity.dart';

final List<AthkarEntity> morningAthkarEntites = [
  const AthkarEntity(
      name: 'آيه الكرسي',
      quantity: 4,
      content:
          'الله لا إلٰه إلا هو الحي القيوم لا تأخذه سنة ولا نوم له ما في السماوات وما في الأرض من ذا الذي يشفع عنده إلا بإذنه يعلم ما بين أيديهم وما خلفهم ولا يحيطون بشيء من علمه إلا بما شاء وسع كرسيه السماوات والأرض ولا يئوده حفظهما وهو العلي العظيم لا إكراه في الدين قد تبين الرشد من الغي فمن يكفر بالطاغوت ويؤمن بالله فقد استمسك بالعروة الوثقىٰ لا انفصام لها والله سميع عليم الله ولي الذين آمنوا يخرجهم من الظلمات إلى النور ۖ والذين كفروا أولياؤهم الطاغوت يخرجونهم من النور إلى الظلمات ۗ أولٰئك أصحاب النار ۖ هم فيها خالدون.'),
  const AthkarEntity(
      name: 'سورة الاخلاص', quantity: 4, content: 'سورة الاخلاص'),
  const AthkarEntity(
      name: 'سورة التوحيد', quantity: 4, content: 'محتوى سورة التوحيد'),
];
final List<AthkarEntity> sleepingAthkarEntites = [
  const AthkarEntity(name: 'دعاء', quantity: 4, content: 'محتوى الدعاء '),
  const AthkarEntity(
      name: 'سورة التوحيد', quantity: 4, content: 'محتوى سورة التوحيد'),
  const AthkarEntity(
      name: 'سورة التوحيد', quantity: 4, content: 'محتوى سورة التوحيد'),
  const AthkarEntity(
      name: 'سورة التوحيد', quantity: 4, content: 'محتوى سورة التوحيد'),
];

final List<AthkarEntity> nightAthkarEntites = [
  const AthkarEntity(
      name: 'آيه الكرسي', quantity: 4, content: 'محتوى آيه الكرسي'),
  const AthkarEntity(
      name: 'سورة الاخلاص', quantity: 4, content: 'سورة الاخلاص'),
];

class StaticAthkarData {
  static final List<AthkarCategory> athkarCategories = [
    AthkarCategory(
        name: 'اذكار الصباح',
        athkarEntities: morningAthkarEntites,
        icon: IconPath.morningAthkarIcon),
    AthkarCategory(
        name: 'اذكار النوم',
        athkarEntities: sleepingAthkarEntites,
        icon: IconPath.morningAthkarIcon),
    AthkarCategory(
        name: 'اذكار المساء',
        athkarEntities: nightAthkarEntites,
        icon: IconPath.morningAthkarIcon),
  ];
}
