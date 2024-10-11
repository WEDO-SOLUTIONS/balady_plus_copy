class BottomNavigationPickItemService {
  Function(int navBar)? _onPickItem;

  Future<void> pickBottomNavigationItem(int navBar) async {
    if (_onPickItem != null) {
      _onPickItem!(navBar);
    }
  }

  set onPickItemCallBack(Function(int navBar) callback) {
    _onPickItem = callback;
  }
}

BottomNavigationPickItemService bottomNavigationPickItemService =
    BottomNavigationPickItemService();
