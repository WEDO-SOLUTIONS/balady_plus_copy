import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/services/local/config.dart';
import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, IconPath, trans;
import '../../../_shared_feature_/shared/shared_feature_exports.dart';
import '../../bottom_navigation_exports.dart'
    show
        BottomNavigationBarMapping,
        BottomNavigationModel,
        bottomNavigationPickItemService,
        BottomNavigationStreamService;

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({
    Key? key,
  }) : super(key: key);

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationPage> {
  late BottomNavigationStreamService _bottomNavigationStreamService;
  late List<BottomNavigationModel> _listOfBottomNavigation;

  late int count;

  @override
  void initState() {
    super.initState();
    _listOfBottomNavigation =
        BottomNavigationModel.getListOfBottomNavigationsFromListOfJsons(
      defaultConfiguration["BottomNavigationBar"],
    );
    _bottomNavigationStreamService = BottomNavigationStreamService(
      _listOfBottomNavigation,
      defaultItemIndex: 0,
    );

    count = 0;

    bottomNavigationPickItemService.onPickItemCallBack = _onPickItem;
  }

  _onPickItem(int index) async {
    _bottomNavigationStreamService.pickItem(index);
  }

  @override
  void dispose() {
    _bottomNavigationStreamService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return Future.value(true);
      },
      child: StreamBuilder<BottomNavigationModel>(
        initialData: _bottomNavigationStreamService.defaultItem,
        stream: _bottomNavigationStreamService.itemStream,
        builder: (context, snapshot) => Scaffold(
          body: BottomNavigationBarMapping.mapStringKeyToScreen(
            snapshot.data!.labelKey!,
            arguments: _getScreenBasedArguments(snapshot.data!.label),
          ),
          // wrap container to builder widget to ignore this problem:
          // Scaffold.of() called with a context that does not contain a Scaffold
          bottomNavigationBar: BottomNavigationBarWidget(
            listOfBottomNavigation: _listOfBottomNavigation,
            bottomNavigationStreamService: _bottomNavigationStreamService,
            bottomNavigationModel: snapshot.data!,
          ),
        ),
      ),
    );
  }

  Object? _getScreenBasedArguments(String? key) {
    return null;
  }
}

class BottomNavigationBarWidget extends StatelessWidget {
  BottomNavigationBarWidget({
    Key? key,
    required List<BottomNavigationModel> listOfBottomNavigation,
    required BottomNavigationStreamService bottomNavigationStreamService,
    required BottomNavigationModel bottomNavigationModel,
  })  : _listOfBottomNavigations = listOfBottomNavigation,
        _bottomNavigationStreamService = bottomNavigationStreamService,
        _bottomNavigationModel = bottomNavigationModel,
        super(key: key);

  final List<BottomNavigationModel> _listOfBottomNavigations;
  final BottomNavigationStreamService _bottomNavigationStreamService;
  final BottomNavigationModel _bottomNavigationModel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Builder(
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.bottomNavigationShadow.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 16,
              offset: const Offset(0, -8), // changes position of shadow
            ),
          ],
          color: AppColor.white,
        ),
        width: size.width,
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _listOfBottomNavigations
              .map((item) => CustomInkWellButtonWidget(
                    btnPressed: () => _bottomNavigationStreamService.pickItem(
                      item.id! - 1,
                    ),
                    widget: SizedBox(
                      width: size.width / _listOfBottomNavigations.length,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomSvgIconWidget(
                                  item.id == _bottomNavigationModel.id
                                      ? item.activeIcon ??
                                          IconPath.bottomNavigationHomeIcon
                                      : item.icon ??
                                          IconPath.bottomNavigationHomeIcon,
                                  iconSize: 24,
                                  iconColor:
                                      item.id == _bottomNavigationModel.id
                                          ? AppColorsTheme.primary700
                                          : AppColor.hunterGreen,
                                ),
                                const CustomVerticalSpace(height: 7.0),
                                CustomTextWidget(
                                  trans(item.label ?? ""),
                                  maxLines: 1,
                                  fontColor:
                                      item.id == _bottomNavigationModel.id
                                          ? AppColorsTheme.primary700
                                          : AppColor.hunterGreen,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  topLeft: Radius.circular(12)),
                              color: item.id == _bottomNavigationModel.id
                                  ? AppColorsTheme.primary700
                                  : Colors.transparent,
                              shape: BoxShape.rectangle,
                            ),
                            width: 12,
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
