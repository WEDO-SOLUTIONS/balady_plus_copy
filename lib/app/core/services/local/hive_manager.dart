import 'package:hive_ce_flutter/hive_flutter.dart';

//----- You can imagine Box like a Table of database -------
class HiveManager {
  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    // open all needed boxed before app running to use it later without await
    // await _openAllNeededBoxes();
  }

  // static Future<void> _openAllNeededBoxes() async {
  //   // open auth box to check if user exist or not
  //   await openBox(boxName: LocalStorageKey.onboardingKey);
  // }

  static Future<bool> checkExistsBox({required String boxName}) async => await Hive.boxExists(boxName);

  static Future<bool> checkExistsKeyBox({required String boxName, required String key}) async {
    Box box = await getOpenedBox(boxName: boxName);
    return Future.value(box.containsKey(key));
  }

  static bool checkOpenedBox({required String boxName}) => Hive.isBoxOpen(boxName);

  static Future<Box> openBox({required String boxName}) async => await Hive.openBox(boxName);

  static Future<Box> getOpenedBox({required String boxName}) async {
    final checkIfOpened = Hive.isBoxOpen(boxName);
    if (checkIfOpened) {
      return Future.value(Hive.box(boxName));
    } else {
      return await openBox(boxName: boxName);
    }
  }

  static Future<Map<dynamic, dynamic>> readEntriesBox({required String boxName}) async {
    Box box = await getOpenedBox(boxName: boxName);
    return Future.value(box.toMap());
  }

  static Future<dynamic> readValueBox({required String boxName, required String key, dynamic defaultValue}) async {
    Box box = await getOpenedBox(boxName: boxName);
    return Future.value(box.get(key, defaultValue: defaultValue));
  }

  static Future<dynamic> readValueByIndexBox({required String boxName, required int index}) async {
    Box box = await getOpenedBox(boxName: boxName);
    return Future.value(box.getAt(index));
  }

  static Future<void> writeValueBox({required String boxName, required String key, required dynamic value}) async {
    Box box = await getOpenedBox(boxName: boxName);
    await box.put(key, value);
  }

  static Future<void> writeValueAtIndexBox<T>({
    required String boxName,
    required int index,
    required dynamic value,
  }) async {
    Box box = await getOpenedBox(boxName: boxName);
    await box.putAt(index, value);
  }

  static Future<void> writeEntriesBox<E, T>({required String boxName, required Map<E, T> entries}) async {
    Box box = await getOpenedBox(boxName: boxName);
    await box.putAll(entries);
  }

  static Future<void> deleteBox({required String boxName}) async {
    Box box = await getOpenedBox(boxName: boxName);
    await box.deleteFromDisk();
  }

  static Future<void> deleteEntriesBox({required String boxName}) async {
    Box box = await getOpenedBox(boxName: boxName);
    await box.clear();
  }

  static Future<void> deleteValueBox({required String boxName, required String key}) async {
    Box box = await getOpenedBox(boxName: boxName);
    await box.delete(key);
  }

  static Future<void> deleteValueByIndexBox<T>({required String boxName, required int index}) async {
    Box box = await getOpenedBox(boxName: boxName);
    await box.deleteAt(index);
  }

  static Future<void> deleteAllSpecifiedKeysBox<T>({required String boxName, required List<T> keys}) async {
    Box box = await getOpenedBox(boxName: boxName);
    await box.deleteAll(keys);
  }

  static Future<void> closeOpenedBox({required Box box}) async => await box.close();

  static Future<void> closeOpenedBoxWithName({required String boxName}) async {
    Box box = await getOpenedBox(boxName: boxName);
    await box.close();
  }

  static Future<void> closeAllBoxes() async => await Hive.close();
}
