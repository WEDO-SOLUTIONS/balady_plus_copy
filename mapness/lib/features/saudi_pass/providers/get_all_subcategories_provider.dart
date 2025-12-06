import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_all_subcategories_provider.g.dart';

@riverpod
class GetAllSubCategories extends _$GetAllSubCategories {
  @override
  Future<Iterable<SubCategory>> build(Iterable<String> categoryIds) async {
    final repository = await ref.read(saudiPassRepositoryProvider.future);

    final subcategoriesFutures = categoryIds.map((id) async {
      final subs = await repository.getSubcategories(categoryId: id);
      return subs
          .map((sub) => SubCategory(id: sub.id, name: sub.name, categoryId: id))
          .toList();
    }).toList();

    final results = await Future.wait(subcategoriesFutures);

    final subcategories = results.expand((it) => it).toList();

    return subcategories;
  }
}
