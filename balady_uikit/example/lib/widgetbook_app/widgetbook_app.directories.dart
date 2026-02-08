import 'package:example/widgetbook_app/use_cases/ab_points_demo/ab_points_demo.dart';
import 'package:example/widgetbook_app/use_cases/ab_road_demo/ab_route_demo.dart';
import 'package:example/widgetbook_app/use_cases/avatar/avatar_demo.dart';
import 'package:example/widgetbook_app/use_cases/badge/badge_demo.dart';
import 'package:example/widgetbook_app/use_cases/bottom_action_bar/bottom_action_bar.dart';
import 'package:example/widgetbook_app/use_cases/buttons/button_demo.dart';
import 'package:example/widgetbook_app/use_cases/check_box/check_box.dart';
import 'package:example/widgetbook_app/use_cases/chips/chips_demo.dart';
import 'package:example/widgetbook_app/use_cases/colors/colors.dart';
import 'package:example/widgetbook_app/use_cases/confetti_animation/confetti_demo.dart';
import 'package:example/widgetbook_app/use_cases/content_row/content_row.dart';
import 'package:example/widgetbook_app/use_cases/counter/counter.dart';
import 'package:example/widgetbook_app/use_cases/icons/icons_demo.dart';
import 'package:example/widgetbook_app/use_cases/loader/loader_demo.dart';
import 'package:example/widgetbook_app/use_cases/maneuver_and_limits/maneuver_and_limits_demo.dart';
import 'package:example/widgetbook_app/use_cases/map_control/map_controls_demo.dart';
import 'package:example/widgetbook_app/use_cases/search_input/search_demo.dart';
import 'package:example/widgetbook_app/use_cases/slider/silder_demo.dart';
import 'package:example/widgetbook_app/use_cases/sliver_align_box/sliver_align_box_demo.dart';
import 'package:example/widgetbook_app/use_cases/spacings/spacings.dart';
import 'package:example/widgetbook_app/use_cases/stories/stories_demo.dart';
import 'package:example/widgetbook_app/use_cases/tabs/tabs_demo.dart';
import 'package:example/widgetbook_app/use_cases/tabs_row_v2/tabs_row_v2_demo.dart';
import 'package:example/widgetbook_app/use_cases/text_input/inputs_demo.dart';
import 'package:example/widgetbook_app/use_cases/toggle/toggle.dart';
import 'package:example/widgetbook_app/use_cases/top_bar/top_bar_demo.dart';
import 'package:example/widgetbook_app/use_cases/typography/typography_demo.dart';
import 'package:widgetbook/widgetbook.dart';

final directories = <WidgetbookNode>[
  WidgetbookFolder(
    name: 'Colors and Typography',
    children: [
      WidgetbookUseCase(
        name: 'Typography',
        builder: typographyDemo,
      ),
      WidgetbookUseCase(
        name: 'Colors',
        builder: colorsDemo,
      ),
      WidgetbookUseCase(
        name: 'Spacings',
        builder: spacingsDemo,
      ),
    ],
  ),
  WidgetbookFolder(
    name: 'widgets',
    children: [
      WidgetbookUseCase(
        name: 'Icons',
        builder: iconsDemo,
      ),
      WidgetbookUseCase(
        name: 'ABRoute [Ready]',
        builder: abRouteDemo,
      ),
      WidgetbookUseCase(
        name: 'ABPoints [Ready]',
        builder: abPointsDemo,
      ),
      WidgetbookUseCase(
        name: 'Avatar [Ready]',
        builder: avatarDemo,
      ),
      WidgetbookUseCase(
        name: 'Badge',
        builder: badgeDemo,
      ),
      WidgetbookUseCase(
        name: 'Button [Ready, Need Overview], IconButton',
        builder: buttonsDemo,
      ),
      WidgetbookUseCase(
        name: 'BottomActionBar [Ready, Need Overview]',
        builder: bottomActionBarWork,
      ),
      WidgetbookUseCase(
        name: 'CheckBox [Ready]',
        builder: checkBoxWork,
      ),
      WidgetbookUseCase(
        name: 'Chips [Ready]',
        builder: chipsWidgetWork,
      ),
      WidgetbookUseCase(
        name: 'ContentRow [Ready]',
        builder: contentRowDemo,
      ),
      WidgetbookUseCase(
        name: 'Counter [Ready]',
        builder: counterWork,
      ),
      WidgetbookUseCase(
        name: 'Input, TextArea [Ready]',
        builder: inputDemo,
      ),
      WidgetbookUseCase(
        name: 'Loader [Ready]',
        builder: loadingWidgetDemo,
      ),
      WidgetbookUseCase(
        name: 'Maneuver and limits [Ready]',
        builder: maneuverAndLimitsDemo,
      ),
      WidgetbookUseCase(
        name: 'Map controls [Ready]',
        builder: mapControls,
      ),
      WidgetbookUseCase(
        name: 'SearchInput [Ready]',
        builder: searchDemo,
      ),
      WidgetbookUseCase(
        name: 'Stories [Ready]',
        builder: storiesDemo,
      ),
      WidgetbookUseCase(
        name: 'TabBar [Ready]',
        builder: tabsDemo,
      ),
      WidgetbookUseCase(
        name: 'TabBar Row V2 [Ready]',
        builder: tabsRowV2WidgetDemo,
      ),
      WidgetbookUseCase(
        name: 'Toggle [Ready]',
        builder: toggleWork,
      ),
      WidgetbookUseCase(
        name: 'Top Bar [Ready]',
        builder: topBarDemo,
      ),
    ],
  ),
  WidgetbookFolder(
    name: 'Additional widgets',
    children: [
      WidgetbookUseCase(
        name: '21. Slider',
        builder: sliderDemo,
      ),
      WidgetbookUseCase(
        name: '100. Confetti animation',
        builder: confetti,
      ),
      WidgetbookUseCase(
        name: '101. Sliver Align Box',
        builder: sliverAlignBoxWork,
      ),
    ],
  ),
];
