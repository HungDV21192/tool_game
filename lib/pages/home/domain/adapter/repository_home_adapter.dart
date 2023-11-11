
import 'package:tool_eat_all_game/pages/home/domain/entity/block_type_enum.dart';

abstract class IHomeRepository {
  Future<List<BlockType>> getCases();
}