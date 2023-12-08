import '../../domain/entities/test.dart';

class TestModel extends TestEntity {
  TestModel({super.id, super.name});
  factory TestModel.fromMap(Map<String, dynamic> json) => TestModel();
}
