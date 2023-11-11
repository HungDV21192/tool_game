
import 'package:tool_eat_all_game/pages/home/domain/entity/block_type_enum.dart';
import 'package:tool_eat_all_game/pages/home/presentation/controllers/teleport_manager.dart';

void fakeLevelForTest(List<List<int>> matrixTileMap, TeleportManager _teleportManager){
  matrixTileMap[0][0] = BlockType.normal.index;
  matrixTileMap[0][1] = BlockType.normal.index;
  matrixTileMap[0][2] = BlockType.edgeTopRight.index;
  matrixTileMap[1][2] = BlockType.normal.index;
  matrixTileMap[2][2] = BlockType.normal.index;
  matrixTileMap[3][2] = BlockType.start.index;
}