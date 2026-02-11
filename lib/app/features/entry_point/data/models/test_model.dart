import '../../domain/entities/test.dart';

class TestModel extends TestEntity {
  const TestModel({super.id, super.name});
  factory TestModel.fromMap(Map<String, dynamic> json) => TestModel();
}
