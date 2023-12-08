class BottomNavigationPickItemService {
  Function(int index)? _onPickItem;

  Future<void> pickBottomNavigationItem(int index) async {
    if (_onPickItem != null) {
      _onPickItem!(index);
    }

    return;
  }

  set onPickItemCallBack(Function(int index) callback) {
    _onPickItem = callback;
  }
}

BottomNavigationPickItemService bottomNavigationPickItemService =
    BottomNavigationPickItemService();
