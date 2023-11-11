import 'package:tool_eat_all_game/pages/home/data/home_api_provider.dart';
import 'package:tool_eat_all_game/pages/home/domain/adapter/repository_home_adapter.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/block_type_enum.dart';


class HomeRepository implements IHomeRepository {
  HomeRepository({required this.provider});
  final IHomeProvider provider;

  @override
  Future<List<BlockType>> getCases() async {
    throw Exception();
  }
}