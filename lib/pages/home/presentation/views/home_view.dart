import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/block_type_enum.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/feature_tool.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/game_state.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/move_enum.dart';
import 'package:tool_eat_all_game/pages/home/presentation/controllers/home_controller.dart';
import 'package:tool_eat_all_game/utils/constants.dart';
import 'package:tool_eat_all_game/utils/import_util.dart';
import 'package:tool_eat_all_game/utils/ui.dart';
import 'package:tool_eat_all_game/utils/web_util.dart';
import 'package:tool_eat_all_game/widgets/block_tool_widget.dart';
import 'package:tool_eat_all_game/widgets/feature_tool_item.dart';
import 'package:tool_eat_all_game/widgets/intro_block_dialog_view.dart';
import 'package:tool_eat_all_game/widgets/text_padding.dart';
import 'package:tool_eat_all_game/widgets/tile_map_cell.dart';
import 'package:tool_eat_all_game/pages/home/presentation/views/test_game_view.dart';
import 'package:tool_eat_all_game/main.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,//white
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: matrixMaxCol * sizeBlock,
                height: matrixMaxRow * sizeBlock,
                margin: const EdgeInsets.only(right: 72),
                child: Listener(
                  child: Obx(() => GridView.count(
                    crossAxisCount: controller.matrixTileMap.first.length,
                    shrinkWrap: true,
                    children: controller.matrixTileMapListInDexInGridView.map((index) => _tileMapCell(index))
                        .toList(),
                  )),
                  onPointerDown: (details){
                    switch(controller.featureTool.value){
                      case FeatureTool.area:
                        if(controller.blockToolSelected != null){
                          controller.drawAreaCells.clear();
                          var downTouch = controller.indexRowColLineOrAreaCellsByTouchLocalPosition(localPostion: details.localPosition);
                          if(downTouch != null){
                            controller.drawAreaCells.add(downTouch);
                            controller.refreshUIByRefreshMatrixTileMap();
                          }
                        }
                        break;
                      case FeatureTool.clear:
                        controller.drawAreaCells.clear();
                        var downTouch = controller.indexRowColLineOrAreaCellsByTouchLocalPosition(localPostion: details.localPosition);
                        if(downTouch != null){
                          controller.drawAreaCells.add(downTouch);
                          controller.refreshUIByRefreshMatrixTileMap();
                        }
                        break;
                      default:
                        break;
                    }
                  },
                  onPointerMove: (details){
                    switch(controller.featureTool.value){
                      case FeatureTool.area:
                        if(controller.blockToolSelected != null) {
                          controller.updateDrawAreaByTouchLocalPosition(
                              localPosition: details.localPosition);
                        }
                        break;
                      case FeatureTool.clear:
                        controller.updateDrawAreaByTouchLocalPosition(localPosition: details.localPosition);
                        break;
                      default:
                        break;
                    }
                  },
                  onPointerUp: (details){
                    switch(controller.featureTool.value){
                      case FeatureTool.area:
                        if(controller.blockToolSelected != null) {
                          controller.endDrawAreaCellsByTouchLocalPosition(
                              localPosition: details.localPosition);
                        }
                        break;
                      case FeatureTool.clear:
                        controller.endClearAreaCellsByTouchLocalPosition(
                            localPosition: details.localPosition);
                        break;
                      default:
                        break;
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                const SizedBox(
                  width: 4,
                ),
                listBlockToolFeatureWidget(),
                const SizedBox(
                  width: 24,
                ),
                listBlockToolBuildMapWidget(),
                Container(
                  width: 1,
                  height: double.maxFinite,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
                  color: Colors.black12,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tileMapCell(int index){
    var block = controller.blockByIndexGridFullTileMap(indexGrid: index);
    Color? colorBorder;
    if(controller.isShowFocusBorderTileMapCell(index)){
      if(controller.featureTool.value == FeatureTool.area){
        colorBorder = Colors.green;
      } else if(controller.featureTool.value == FeatureTool.clear){
        colorBorder = Colors.red;
      }
    }
    return TileMapCell(
      block: block,
      size: sizeBlock,
      idCoupleTelepot: controller.idTeleportCoupleFullTileMap(block, index),
      colorFocusBorder: colorBorder,
      onPressed: () {
        switch(controller.featureTool.value){
          case FeatureTool.clear:
            controller.clearBlockInCellMapByIndex(index);
            break;
          default:
            break;
        }
      },
    );
  }
  void _showDialogTestGame() async {
    controller.refreshMatrixTileMapShortAndInitForPlayGame();
    controller.moveType.value = MoveType.none;
    controller.curGameState.value = GameState.playing;
    var result = await showGeneralDialog(
        context: Get.context!,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(Get.context!).modalBarrierDismissLabel,
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return const TestGameView();
        });
    controller.curGameState.value = GameState.buildLevel;
    if(true == result){
      await Future.delayed(const Duration(milliseconds: 500));
      exportLevel();
    }
  }

  Widget listBlockToolFeatureWidget() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.black26,
            width: 1,
          ),
          right: BorderSide(
            color: Colors.black26,
            width: 1,
          ),
        ),
      ),
      height: double.maxFinite,
      margin: const EdgeInsets.symmetric(vertical: 32),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.topCenter,
      child: Obx(() => Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Text(
                "Draw Type".toUpperCase(),
                style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 42,
              ),
              Container(
                height: 2,
                width: 150,
                color: Colors.black12,
              ),
              const SizedBox(
                height: 24,
              ),
              _featureToolItemWidget(FeatureTool.area),
              const SizedBox(
                height: 32,
              ),
              controller.isMatrixTileMapIsEmpty()
                  ? const SizedBox()
                  : _featureToolItemWidget(FeatureTool.clear),
              SizedBox(
                height: controller.isMatrixTileMapIsEmpty() ? 0 : 32,
              ),
              controller.isMatrixTileMapIsEmpty()
                  ? const SizedBox()
                  : FeatureToolItem(
                      feature: FeatureTool.clearAll,
                      onPressed: () async {
                        var result = await showConfirmDialog(
                            context: Get.context!,
                            content: "Xác nhận xóa tiled map đang làm?");
                        if (true == result) {
                          controller.clearAllTileMapWorking();
                          controller.statusImportFileLevel.value = '';
                          controller.resetUndoManager();
                        }
                      },
                    ),
              const SizedBox(height: 48,),
              ElevatedButton(
                onPressed: () {
                  controller.undoLastAction();
                },
                style: ElevatedButton.styleFrom(
                    elevation: 12.0,
                    backgroundColor: Colors.blueGrey,
                    textStyle: const TextStyle(color: Colors.white)),
                child: const TextPadding(
                  'Undo',
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () {
                  controller.reUndoLastAction();
                },
                style: ElevatedButton.styleFrom(
                    elevation: 12.0,
                    backgroundColor: Colors.blueGrey,
                    textStyle: const TextStyle(color: Colors.white)),
                child: const TextPadding(
                  'Re Undo',
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 64,),
              ElevatedButton(
                onPressed: () {
                  handleImportDataFromFileLevel();
                },
                style: ElevatedButton.styleFrom(
                    elevation: 12.0,
                    backgroundColor: Colors.teal,
                    textStyle: const TextStyle(color: Colors.white)),
                child: const TextPadding(
                  'Import from file',
                  padding: EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16,),
              Text(controller.statusImportFileLevel.value,
                style: const TextStyle(color: Colors.black, fontStyle: FontStyle.italic, fontWeight: FontWeight.normal, fontSize: 14),),
              const SizedBox(height: 36,),
              ElevatedButton(
                onPressed: (){
                  if(controller.isCanPlayOrExportLevelGame()){
                    if(controller.isLevelHasTelepotBlockIsSatisfyCondition()){
                      _showDialogTestGame();
                    }  else {
                      showMessageToUserNowToast(BlockType.telepot.intro, isLongToast: true);
                    }
                  } else {
                    showMessageToUserNowToast("Level cần có ít nhất 1 start point và 1 block!", isLongToast: true);
                  }
                },
                style: ElevatedButton.styleFrom(
                    elevation: 12.0,
                    textStyle: const TextStyle(color: Colors.white)),
                child: const TextPadding(
                  'Test Level',
                  padding: EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () {
                  if(controller.isCanPlayOrExportLevelGame()){
                    if(controller.isLevelHasTelepotBlockIsSatisfyCondition()){
                      exportLevel();
                    }  else {
                      showMessageToUserNowToast(BlockType.telepot.intro, isLongToast: true);
                    }
                  } else {
                    showMessageToUserNowToast("Level cần có ít nhất 1 start point và 1 block!", isLongToast: true);
                  }
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
              const SizedBox(height: 16,),
              Text(controller.statusExportLevel.value, style: const TextStyle(color: Colors.pink, fontStyle: FontStyle.italic, fontSize: 13.5),),
              const Spacer(),
              const Text(
                "Version: $versionBuildRelease",
                style: TextStyle(color: Colors.blueAccent, fontSize: 13),
              ),
            ],
          )),
    );
  }

  void handleImportDataFromFileLevel() async{
    try{
      var data = await importFileJsonLevel();
      if(data != null && data.length == 2){
        var nameFile = data[0];
        var dataLevel = data[1];
        controller.importDataFromFileLevel(dataLevel);
        var dateFormat = DateFormat("HH:mm");
        controller.statusImportFileLevel.value = 'Đã import $nameFile vào lúc: ${dateFormat.format(DateTime.now())}';
      }
    }catch(e){
      showMessageToUserNowToast("Có lỗi xẩy ra, vui lòng thử lại!", isLongToast: true);
    }
  }

  Widget _featureToolItemWidget(FeatureTool featureTool) {
    return FeatureToolItem(
      feature: featureTool,
      isSelect: controller.featureTool.value == featureTool,
      onPressed: () {
        controller.featureTool.value = featureTool;
      },
    );
  }

  Widget listBlockToolBuildMapWidget() {
    return SizedBox(
      width: sizeBlockTool * 4 + 32,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 45,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "List Block".toUpperCase(),
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(width: 12,),
              InkWell(
                onTap: (){
                  showDialogIntroBlock();
                },
                child: Image.asset('assets/book.png', width: 45,height: 45,),
              )
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Container(
            height: 2,
            width: 250,
            color: Colors.black12,
          ),
          const SizedBox(
            height: 12,
          ),
          const Text(
            "Start point",
            style: TextStyle(
                color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 16,
          ),
          Obx(() => BlockToolItem(
            blockTool: controller.startBlockTool.value,
            onPressed: () {
              controller.setStartBlockToolChoose();
            },
          )),
          Obx(() => GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 48),
            children: controller.blockToolList
                .map((blockTool) => Padding(
              padding: const EdgeInsets.all(4),
              child: BlockToolItem(
                blockTool: blockTool,
                onPressed: () {
                  if(blockTool.isAvailable){
                    controller.setBlockToolChoose(blockTool);
                  }
                },
              ),
            ))
                .toList(),
          )),
        ],
      ),
    );
  }

  void exportLevel() async {
    var result = await showDialogConfirmExportLevel(Get.context!, plainTextContent: controller.dataLevelExport());
    if(true == result){
      var dateFormat = DateFormat("HH:mm");
      controller.statusExportLevel.value = 'Đã export $lastLevelExportName vào lúc: ${dateFormat.format(DateTime.now())}';
    }
  }

  void showDialogIntroBlock() {
    showGeneralDialog(
        context: Get.context!,
        barrierDismissible: true,
        barrierLabel:
        MaterialLocalizations.of(Get.context!).modalBarrierDismissLabel,
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return const IntroBlocksView();
        });
  }

}
