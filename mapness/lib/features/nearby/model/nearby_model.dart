import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';

class NearbyItemData extends Equatable {
  final DirectoryObjectMessage object;

  const NearbyItemData({required this.object});

  @override
  List<Object?> get props => [object];
}
