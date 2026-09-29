import 'package:dgis_map/library.dart';
import 'package:flutter_test/flutter_test.dart';

const _viewId = 7;
const _codec = MapApi.pigeonChannelCodec;

String _hostChannel(String method) => 'dev.flutter.pigeon.dgis_map_platform_interface.MapApi.${method}map_$_viewId';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final sentArgs = <List<Object?>>[];
  late DgisMapController controller;

  void mockHostCall(String method, Object? Function(List<Object?> args) reply) {
    messenger.setMockMessageHandler(_hostChannel(method), (message) async {
      final args = _codec.decodeMessage(message) as List<Object?>? ?? const [];
      return _codec.encodeMessage(<Object?>[reply(args)]);
    });
  }

  setUp(() async {
    sentArgs.clear();
    mockHostCall('initialize', (_) => InitializeMessage(wasInitialized: false, errorDescription: ''));
    mockHostCall('createMapObjectManager', (args) {
      sentArgs.add(args);
      return MapObjectManagerMessage(id: 'manager-${sentArgs.length}');
    });

    controller = DgisMapController(_viewId);
    await controller.initialize();
  });

  tearDown(() {
    messenger
      ..setMockMessageHandler(_hostChannel('initialize'), null)
      ..setMockMessageHandler(_hostChannel('createMapObjectManager'), null);
  });

  test('manager keeps generalization by default', () async {
    await controller.createMapObjectManager(layerId: '920277');

    expect(sentArgs, [
      ['920277', true],
    ]);
  });

  test('manager can be created without generalization', () async {
    await controller.createMapObjectManager(layerId: '977194', generalization: false);

    expect(sentArgs, [
      ['977194', false],
    ]);
  });
}
