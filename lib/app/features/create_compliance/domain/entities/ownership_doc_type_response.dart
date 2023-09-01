import 'package:equatable/equatable.dart';

class ComplinaceLookUpResponse extends Equatable {
  final List<ComplinaceLookUpItem>? items;

  const ComplinaceLookUpResponse({this.items});

  @override
  List<Object?> get props => [items];
}

class ComplinaceLookUpItem extends Equatable {
  final int? id;
  final String? name;

  const ComplinaceLookUpItem({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
