import 'dart:async' show StreamController;

import '../../../bottom_navigation_exports.dart' show BottomNavigationModel;

class BottomNavigationStreamService {
  late StreamController<BottomNavigationModel> _bottomNavigationController;
  late BottomNavigationModel defaultItem;
  late List<BottomNavigationModel> _listOfBottomNavigation;

  BottomNavigationStreamService(
      List<BottomNavigationModel> listOfBottomNavigation,
      {int defaultItemIndex = 0}) {
    _bottomNavigationController = StreamController.broadcast();
    defaultItem = listOfBottomNavigation.elementAt(defaultItemIndex);
    _listOfBottomNavigation = listOfBottomNavigation;
  }

  Stream<BottomNavigationModel> get itemStream =>
      _bottomNavigationController.stream;

  void pickItem(int itemIndex) {
    _bottomNavigationController.sink.add(
      _listOfBottomNavigation.elementAt(itemIndex),
    );
  }

  void close() {
    _bottomNavigationController.close();
  }
}
