import 'package:get/get.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/block.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/game_state.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/move_enum.dart';
import 'package:tool_eat_all_game/pages/home/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:tool_eat_all_game/utils/constants.dart';
import 'package:tool_eat_all_game/widgets/cell_block_game.dart';
import 'package:tool_eat_all_game/widgets/text_padding.dart';
bool isFullHeightDialog = false;
double sizeBlockPlaying = 34.0;
class TestGameView extends GetView<HomeController> {
  const TestGameView({Key? key}) : super(key: key);
  void _reCalculateSizeBlockGame(){
    var countRow = controller.matrixBlockForPlayGame.length;
    isFullHeightDialog = false;
    if(countRow <= 14){
      sizeBlockPlaying = sizeBlock * 1.48;
    } else if(countRow <= 21){
      isFullHeightDialog = true;
      sizeBlockPlaying = sizeBlock * 1.24;
    } else if(countRow <= 24){
      isFullHeightDialog = true;
      sizeBlockPlaying = sizeBlock * 0.98;
    } else {
      isFullHeightDialog = true;
      sizeBlockPlaying = sizeBlock * 0.88;
    }
    if(sizeBlockPlaying > 56){
      sizeBlockPlaying = 56;
    }
  }
  @override
  Widget build(BuildContext context) {
    _reCalculateSizeBlockGame();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.2,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                minHeight: MediaQuery.of(context).size.height * 0.6,
                maxHeight: MediaQuery.of(context).size.height * (isFullHeightDialog ? 0.96 : 0.9)),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 12,),
                Listener(
                  child: Container(
                    height: double.maxFinite,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.green.withOpacity(0.6),
                          width: 1,
                        ),
                        right: BorderSide(
                          color: Colors.green.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 200,right: 100),
                    child: Obx(() => _tileMapGamePlay(context)),
                  ),
                  onPointerDown: (details){
                  //  print("HAO_DV onPointerDown: ${details.localPosition}");
                    controller.pointTouchDown = details.localPosition;
                  },
                  onPointerUp: (details){
                   // print("HAO_DV onPointerUp: ${details.localPosition}");
                    controller.pointTouchUp = details.localPosition;
                    controller.findDirectionMoveTypeByPlayingGame();
                    if(controller.moveType.value != MoveType.none){
                      controller.runBallByPlayingNow();
                    }
                  },
                  onPointerCancel: (details){
                   // print("HAO_DV onPointerCancel: ${details.localPosition}");
                    controller.pointTouchDown = null;
                    controller.pointTouchUp = null;
                  },
                ),
                const SizedBox(width: 12,),
                listButtons(context),
                const SizedBox(width: 36,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  List<List<Block?>> levelMapPlay() => controller.matrixBlockForPlayGame;
  Widget _tileMapGamePlay(BuildContext context) {
    int row = levelMapPlay().length;
    int col = levelMapPlay().first.length;
    return SizedBox(
      width: col * sizeBlockPlaying,
      height: row * sizeBlockPlaying,
      child: GridView.builder(
        itemCount: row * col,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: col),
        itemBuilder: (BuildContext context, int index) {
          var block = controller.blockGameByIndexGridTileMap(index);
          return CellGame(
            block: controller.blockGameByIndexGridTileMap(index),
            size: sizeBlockPlaying,
            idCoupleTelepot: controller.idTeleportCoupleShortTileMapGame(block, index),
            isBallInHere: controller.indexBallPlayInGamePlay() == index,
          );
        },
      ),
    );
  }

  Widget listButtons(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      height: double.maxFinite,
      margin: const EdgeInsets.symmetric(vertical: 64),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black87, width: 2)),
      child: Column(
        children: [
          const SizedBox(
            height: 36,
          ),
          Obx(() => Text(controller.curGameState.value.status, textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 25),)),
          const SizedBox(
            height: 36,
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
                elevation: 12.0,
                backgroundColor: Colors.red,
                textStyle: const TextStyle(color: Colors.white)),
            child: const TextPadding(
              'ĐÓNG',
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            ),
          ),
          const SizedBox(
            height: 36,
          ),
          ElevatedButton(
            onPressed: () {
              controller.replayThisGameTest();
            },
            style: ElevatedButton.styleFrom(
                elevation: 12.0,
                textStyle: const TextStyle(color: Colors.white)),
            child: const TextPadding(
              'Chơi lại',
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
          const SizedBox(
            height: 36,
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(result: true);
            },
            style: ElevatedButton.styleFrom(
                elevation: 12.0,
                backgroundColor: Colors.green,
                textStyle: const TextStyle(color: Colors.white)),
            child: const TextPadding(
              'Export Level',
              padding: EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
