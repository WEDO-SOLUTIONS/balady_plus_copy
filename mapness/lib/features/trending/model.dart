part of 'trending.dart';

class TrendingItem extends Equatable {
  final DirectoryObjectMessage object;

  const TrendingItem({required this.object});

  @override
  List<Object?> get props => [object];
}
