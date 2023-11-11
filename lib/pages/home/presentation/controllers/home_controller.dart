import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/block.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/block_tool.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/data_export.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/feature_tool.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/block_type_enum.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/game_state.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/move_enum.dart';
import 'package:tool_eat_all_game/pages/home/presentation/controllers/fake_level.dart';
import 'package:tool_eat_all_game/pages/home/presentation/controllers/teleport_manager.dart';
import 'package:tool_eat_all_game/pages/home/presentation/controllers/undo_manager.dart';
import 'package:tool_eat_all_game/utils/constants.dart';
import 'package:tool_eat_all_game/utils/ui.dart';

class HomeController extends GetxController {
  final _durationAnimMove = const Duration(milliseconds: 300);
  final _teleportManager = TeleportManager();
  final _undoManager = UndoManager();
  String? matrixTileMapStr;
  var matrixTileMapListInDexInGridView =<int>[];
  final matrixTileMap = List.generate(
    matrixMaxRow,
    (i) => List.generate(matrixMaxCol, (j) => -1),
  ).obs;
  var _matrixTileMapShort = <List<int>>[];
  final matrixBlockForPlayGame = <List<Block?>>[].obs;
  var blockList = [
    Block(blockType: BlockType.start),
    Block(blockType: BlockType.normal),
    Block(
      blockType: BlockType.one,
    ),
    Block(blockType: BlockType.magnet),
    Block(blockType: BlockType.pushTop),
    Block(blockType: BlockType.pushRight),
    Block(blockType: BlockType.pushBottom),
    Block(blockType: BlockType.pushLeft),
    Block(blockType: BlockType.edgeTopLeft),
    Block(blockType: BlockType.edgeTopRight),
    Block(blockType: BlockType.edgeBottomLeft),
    Block(blockType: BlockType.edgeBottomRight),
    Block(blockType: BlockType.telepot),
    Block(blockType: BlockType.bomb),
    Block(blockType: BlockType.tank),
  ].obs;
  var blockToolList = [
    BlockTool(blockType: BlockType.normal),
    BlockTool(blockType: BlockType.one,),
    BlockTool(blockType: BlockType.magnet),
    BlockTool(blockType: BlockType.pushTop),
    BlockTool(blockType: BlockType.pushRight),
    BlockTool(blockType: BlockType.pushBottom),
    BlockTool(blockType: BlockType.pushLeft),
    BlockTool(blockType: BlockType.edgeTopLeft),
    BlockTool(blockType: BlockType.edgeTopRight),
    BlockTool(blockType: BlockType.edgeBottomLeft),
    BlockTool(blockType: BlockType.edgeBottomRight),
    BlockTool(blockType: BlockType.telepot),
    BlockTool(blockType: BlockType.bomb),
    BlockTool(blockType: BlockType.tank, isAvailable: false),
  ].obs;
  var statusExportLevel = ''.obs;
  var statusImportFileLevel = ''.obs;
  var featureTool = FeatureTool.none.obs;
  var startBlockTool = BlockTool(blockType: BlockType.start).obs;
  var moveType = MoveType.none.obs;
  var moveTypeNextByPushTypeBlock = MoveType.none;
  final curGameState = GameState.buildLevel.obs;
  Offset? pointTouchDown, pointTouchUp;
  HomeController();
  var _saveIndexNextByEdgeBlock = [-1,-1];
  var _indexNextTelepotBlock = [-1,-1];
  var drawAreaCells = <List<int>>[];
  BlockTool? blockToolSelected;
  @override
  void onInit() {
    super.onInit();
    _teleportManager.init();
    _undoManager.init();
    for(int i = 0; i < matrixMaxRow * matrixMaxCol; i++){
      matrixTileMapListInDexInGridView.add(i);
    }
    //fakeLevelForTest(matrixTileMap, _teleportManager)c;c
  }
  void resetUndoManager(){
    _undoManager.reset();
  }

  void refreshUIByRefreshMatrixTileMap(){
    var string = '${jsonEncode(matrixTileMap)}|${jsonEncode(drawAreaCells)}';
    if(string != matrixTileMapStr){
      matrixTileMapStr = string;
      matrixTileMap.refresh();
    }
  }

  List<int>? indexRowColLineOrAreaCellsByTouchLocalPosition({required Offset? localPostion}){
    if(localPostion != null){
      var iRow = (localPostion.dy / sizeBlock).floor();
      int jCol = (localPostion.dx /sizeBlock).floor();
      if(iRow >= 0 && iRow < matrixMaxRow && jCol >= 0 && jCol < matrixMaxCol) {
        return [iRow, jCol];
      }
    }
    return null;
  }
  void _clearAllStartBlockInMatrixTileMap(){
    for(int i = 0; i < matrixTileMap.length; i++){
      for(int j = 0; j < matrixTileMap[i].length; j++){
        if(matrixTileMap[i][j] == BlockType.start.index){
          matrixTileMap[i][j] = -1;
        }
      }
    }
  }
  bool get blockToolSelectedIsStart => BlockType.start == blockToolSelected?.blockType;
  void endDrawAreaCellsByTouchLocalPosition({required Offset? localPosition}){
    if(blockToolSelected == null){
      drawAreaCells.clear();
      return;
    }
    List<List<int>> blockIjArrs = [];
    for(var iRowJCount in drawAreaCells){
      if(blockToolSelectedIsStart){
        _clearAllStartBlockInMatrixTileMap();
      }
      int i = iRowJCount[0];
      int j = iRowJCount[1];
      if(blockToolSelected!.blockType != BlockType.telepot && matrixTileMap[i][j] == BlockType.telepot.index){
        _removeIndexJITeleportCouple(iRow: i, jCol: j);
      } else if(blockToolSelected!.blockType == BlockType.telepot){
        _teleportManager.addIndexIJTeleport(iRow: i, jCol: j);
      }
      var prevId = matrixTileMap[i][j];
      var curId = blockToolSelected!.blockType.index;
      matrixTileMap[i][j] = curId;
      if(prevId != curId) {
        blockIjArrs.add([prevId, curId, i, j]);
      }
    }
    if(blockIjArrs.isNotEmpty){
      _undoManager.addMultiToUndoList(blockIjArrs:blockIjArrs);
    }
    drawAreaCells.clear();
    refreshUIByRefreshMatrixTileMap();
  }

  void undoLastAction(){
    var step = _undoManager.undoStep();
    if(step != null){
      var steps = step.iJBlockIdSteps();
      for(var ijVal in steps){
        if(ijVal.length == 4){
          var i = ijVal[2];
          var j = ijVal[3];
          if(i >= 0 && i < matrixMaxRow && j >= 0 && j < matrixMaxCol) {
            matrixTileMap[i][j] = ijVal[0];
          }
        }
      }
      refreshUIByRefreshMatrixTileMap();
    }
  }

  void reUndoLastAction(){
    var step = _undoManager.reUndoStep();
    if(step != null){
      var steps = step.iJBlockIdSteps();
      for(var ijVal in steps){
        if(ijVal.length == 4){
          var i = ijVal[2];
          var j = ijVal[3];
          if(i >= 0 && i < matrixMaxRow && j >= 0 && j < matrixMaxCol){
            matrixTileMap[i][j] = ijVal[1];
          }
        }
      }
      refreshUIByRefreshMatrixTileMap();
    }
  }

  void endClearAreaCellsByTouchLocalPosition({required Offset? localPosition}){
    List<List<int>> blockIjArrs = [];
    for(var iRowJCount in drawAreaCells){
      int i = iRowJCount[0];
      int j = iRowJCount[1];
      if(matrixTileMap[i][j] == BlockType.telepot.index){
        _removeIndexJITeleportCouple(iRow: i, jCol: j);
      }
      var prevId = matrixTileMap[i][j];
      var curId = -1;
      matrixTileMap[i][j] = curId;
      if(prevId != curId) {
        blockIjArrs.add([prevId, curId, i, j]);
      }
    }
    if(blockIjArrs.isNotEmpty){
      _undoManager.addMultiToUndoList(blockIjArrs:blockIjArrs);
    }
    drawAreaCells.clear();
    refreshUIByRefreshMatrixTileMap();
  }

  bool _isSameCellIRowJCol({required List<int> pos1, required List<int> pos2}){
    return pos1[0] == pos2[0] && pos1[1] == pos2[1];
  }
  void updateDrawAreaByTouchLocalPosition({required Offset? localPosition}){
    var iRowJCol = indexRowColLineOrAreaCellsByTouchLocalPosition(localPostion: localPosition);
    if(iRowJCol == null){
      return;
    }
    if(drawAreaCells.isEmpty){
      drawAreaCells.add(iRowJCol);
      refreshUIByRefreshMatrixTileMap();
      return;
    }
    if(featureTool.value == FeatureTool.area && blockToolSelected != null && !blockToolSelected!.blockType.isCanDrawAreaMultiCell){
      drawAreaCells.clear();
      drawAreaCells.add(iRowJCol);
      refreshUIByRefreshMatrixTileMap();
      return;
    }
    if(_isSameCellIRowJCol(pos1: iRowJCol, pos2:  drawAreaCells.first)){
      if(drawAreaCells.length > 1) {
        drawAreaCells.removeRange(1, drawAreaCells.length);
        refreshUIByRefreshMatrixTileMap();
      }
      return;
    }
    // lineOrAreaCells.first 2,5 | iRowJCol: 4,3
    // min: 2,4 | max: 4, 5
    int minIRow = min(iRowJCol[0], drawAreaCells.first[0]); // 2
    int maxIRow = max(iRowJCol[0], drawAreaCells.first[0]); // 4
    int minJCol = min(iRowJCol[1], drawAreaCells.first[1]);//3
    int maxJCol = max(iRowJCol[1], drawAreaCells.first[1]);//5
    var newList = <List<int>>[];
    // 2,3 | 4,5
    for(int i = minIRow; i <= maxIRow; i++){
      for(int j = minJCol; j <= maxJCol; j++){
        if(!_isSameCellIRowJCol(pos1: drawAreaCells.first, pos2:  [i, j]) && !_isSameCellIRowJCol(pos1: iRowJCol, pos2:  [i, j])) {
          newList.add([i, j]);
        }
      }
    }
    newList.insert(0, drawAreaCells.first);
    newList.add(iRowJCol);
    drawAreaCells = newList;
    refreshUIByRefreshMatrixTileMap();
  }

  void updateDrawLinesByTouchLocalPosition({required Offset? localPosition}){
    var iRowJCol = indexRowColLineOrAreaCellsByTouchLocalPosition(localPostion: localPosition);
    if(iRowJCol == null){
      return;
    }
    if(drawAreaCells.isEmpty){
      drawAreaCells.add(iRowJCol);
      refreshUIByRefreshMatrixTileMap();
      return;
    }
    if(_isSameCellIRowJCol(pos1: iRowJCol, pos2:  drawAreaCells.last)){
      return;
    }
    bool isSameLine = (iRowJCol[0] == drawAreaCells.first[0] || iRowJCol[1] == drawAreaCells.first[1]);
    if(!isSameLine){
      drawAreaCells.clear();
      refreshUIByRefreshMatrixTileMap();
    } else {
      var newList = <List<int>>[];
      drawAreaCells.add(iRowJCol);
      for(int i = 1; i < drawAreaCells.length - 1; i++){
        if(_isSameLineAndCenter2Point(from: drawAreaCells.first, to: drawAreaCells.last, pos: drawAreaCells[i])){
          newList.add(drawAreaCells[i]);
        }
      }
      newList.insert(0, drawAreaCells.first);
      newList.add(drawAreaCells.last);
      drawAreaCells = newList;
      refreshUIByRefreshMatrixTileMap();
    }
  }
  bool _isSameLineAndCenter2Point({required List<int> from, required List<int> to, required List<int> pos}){
    if(from[0] == to[0] && to[0] == pos[0]){
      return (pos[1] - from[1]) * (pos[1] - to[1]) < 0;
    }
    if(from[1] == to[1] && to[1] == pos[1]){
      return (pos[0] - from[0]) * (pos[0] - to[0]) < 0;
    }
    return false;
  }
  bool _isContainInLineOrAreaCells(List<int> iRowJCol){
    if(iRowJCol.length != 2){
      return false;
    }
    for(var list in drawAreaCells){
      if(list[0] == iRowJCol[0] && list[1] == iRowJCol[1]){
        return true;
      }
    }
    return false;
  }

  Block? blockByIndexGridFullTileMap({required int indexGrid}) {
    var blockId = blockIdByIndexGridTileMap(indexGrid, matrixTileMap);
    if(blockId < 0){
      return null;
    }
    return blockList.firstWhere((p0) => p0.blockType.index == blockId);
  }

  int countCellsMatrixTileMap() => matrixMaxRow * matrixMaxCol;

  int blockIdByIndexGridTileMap(int index, List<List<int>> matrixMap) {
    if(matrixMap.isEmpty){
      return -1;
    }
    var col = matrixMap.first.length;
    int i = (index / col).floor();
    int j = index % col;
    return matrixMap[i][j];
  }
  Block? blockGameByIndexGridTileMap(int index) {
    if(matrixBlockForPlayGame.isEmpty){
      return null;
    }
    var col = matrixBlockForPlayGame.first.length;
    int i = (index / col).floor();
    int j = index % col;
    return matrixBlockForPlayGame[i][j];
  }

  bool isShowFocusBorderTileMapCell(int index){
    if(featureTool.value != FeatureTool.area && featureTool.value != FeatureTool.clear){
      return false;
    }
    int i = (index / matrixMaxCol).floor();
    int j = index % matrixMaxCol;
    return _isContainInLineOrAreaCells([i,j]);
  }
  void addBlockTypeToCellTileMapByIndex(BlockType blockType, int index) {
    int i = (index / matrixMaxCol).floor();
    int j = index % matrixMaxCol;
    matrixTileMap[i][j] = blockType.index;
    refreshUIByRefreshMatrixTileMap();
  }
  void clearBlockInCellMapByIndex(int index) {
    int i = (index / matrixMaxCol).floor();
    int j = index % matrixMaxCol;
    if (matrixTileMap[i][j] >= 0) {
      if(matrixTileMap[i][j] == BlockType.telepot.index){
        _removeIndexJITeleportCouple(iRow: i, jCol: j);
      }
      matrixTileMap[i][j] = -1;
      if (isMatrixTileMapIsEmpty()) {
        featureTool.value = FeatureTool.none;
      }
      refreshUIByRefreshMatrixTileMap();
    }
  }

  var listIndexRowColBlockOne = <String>[];
  List<int> _indexRowColTelepotNext({required int iRow, required int jCol, bool getFromShortList = true}){
    return _teleportManager.findCoupleOfTeleport(iRow: iRow, jCol: jCol, getFromShortList: getFromShortList);
  }
  void _runBallUp(){
    listIndexRowColBlockOne.clear();
    for(int i = indexRowBallHere;  i >= 0 ; i--){
      var block = matrixBlockForPlayGame[i][indexColBallHere];
      if(block != null){
        newIndexRowBallInMove = i;
        block.isDrew = true;
        if(block.blockType == BlockType.bomb){
          curGameState.value = GameState.lose;
          break;
        }
        if(block.blockType == BlockType.magnet && i < indexRowBallHere){
          break;
        }
        if(block.blockType == BlockType.pushTop && i < indexRowBallHere){
          moveTypeNextByPushTypeBlock = MoveType.up;
          break;
        }
        if(block.blockType == BlockType.pushRight && i < indexRowBallHere){
          moveTypeNextByPushTypeBlock = MoveType.right;
          break;
        }
        if(block.blockType == BlockType.pushBottom && i < indexRowBallHere){
          moveTypeNextByPushTypeBlock = MoveType.down;
          break;
        }
        if(block.blockType == BlockType.pushLeft && i < indexRowBallHere){
          moveTypeNextByPushTypeBlock = MoveType.left;
          break;
        }
        if(block.blockType == BlockType.telepot && i < indexRowBallHere){
          _indexNextTelepotBlock = _indexRowColTelepotNext(iRow: i, jCol: indexColBallHere);
          break;
        }
        if(block.blockType == BlockType.edgeTopLeft){
          if(indexColBallHere + 1 < _matrixTileMapShort.first.length){
            var block = matrixBlockForPlayGame[newIndexRowBallInMove][indexColBallHere + 1];
            if(block != null){
              _saveIndexNextByEdgeBlock = [newIndexRowBallInMove,indexColBallHere + 1];
            }
          }
          break;
        }
        if(block.blockType == BlockType.edgeTopRight){
          if(indexColBallHere - 1 >= 0){
            var block = matrixBlockForPlayGame[newIndexRowBallInMove][indexColBallHere - 1];
            if(block != null){
              _saveIndexNextByEdgeBlock = [newIndexRowBallInMove,indexColBallHere - 1];
            }
          }
          break;
        }
        if(block.blockType == BlockType.one){
          listIndexRowColBlockOne.add('$i|$indexColBallHere');
        }
      } else {
        break;
      }
    }
  }
  void _runBallDown(){
    listIndexRowColBlockOne.clear();
    for(int i = indexRowBallHere;  i < _matrixTileMapShort.length ; i++){
      var block =  matrixBlockForPlayGame[i][indexColBallHere];
      if(block != null){
        newIndexRowBallInMove = i;
        block.isDrew = true;
        if(block.blockType == BlockType.bomb){
          curGameState.value = GameState.lose;
          break;
        }
        if(block.blockType == BlockType.magnet && i > indexRowBallHere){
          break;
        }
        if(block.blockType == BlockType.pushTop && i > indexRowBallHere){
          moveTypeNextByPushTypeBlock = MoveType.up;
          break;
        }
        if(block.blockType == BlockType.pushRight && i > indexRowBallHere){
          moveTypeNextByPushTypeBlock = MoveType.right;
          break;
        }
        if(block.blockType == BlockType.pushBottom && i > indexRowBallHere){
          moveTypeNextByPushTypeBlock = MoveType.down;
          break;
        }
        if(block.blockType == BlockType.pushLeft && i > indexRowBallHere){
          moveTypeNextByPushTypeBlock = MoveType.left;
          break;
        }
        if(block.blockType == BlockType.telepot && i > indexRowBallHere){
          _indexNextTelepotBlock = _indexRowColTelepotNext(iRow: i, jCol: indexColBallHere);
          break;
        }
        if(block.blockType == BlockType.edgeBottomLeft){
          if(indexColBallHere + 1 < _matrixTileMapShort.first.length){
            var block = matrixBlockForPlayGame[newIndexRowBallInMove][indexColBallHere + 1];
            if(block != null){
              _saveIndexNextByEdgeBlock = [newIndexRowBallInMove,indexColBallHere + 1];
            }
          }
          break;
        }
        if(block.blockType == BlockType.edgeBottomRight){
          if(indexColBallHere - 1 >= 0){
            var block = matrixBlockForPlayGame[newIndexRowBallInMove][indexColBallHere - 1];
            if(block != null){
              _saveIndexNextByEdgeBlock = [newIndexRowBallInMove,indexColBallHere - 1];
            }
          }
          break;
        }
        if(block.blockType == BlockType.one){
          listIndexRowColBlockOne.add('$i|$indexColBallHere');
        }
      } else {
        break;
      }
    }
  }
  void _runBallRight(){
    listIndexRowColBlockOne.clear();
    for(int j = indexColBallHere;  j < _matrixTileMapShort.first.length ; j++){
      var block =  matrixBlockForPlayGame[indexRowBallHere][j];
      if(block != null){
        newIndexColBallInMove = j;
        block.isDrew = true;
        if(block.blockType == BlockType.bomb){
          curGameState.value = GameState.lose;
          break;
        }
        if(block.blockType == BlockType.magnet && j > indexColBallHere){
          break;
        }
        if(block.blockType == BlockType.pushTop && j > indexColBallHere){
          moveTypeNextByPushTypeBlock = MoveType.up;
          break;
        }
        if(block.blockType == BlockType.pushRight && j > indexColBallHere){
          moveTypeNextByPushTypeBlock = MoveType.right;
          break;
        }
        if(block.blockType == BlockType.pushBottom && j > indexColBallHere){
          moveTypeNextByPushTypeBlock = MoveType.down;
          break;
        }
        if(block.blockType == BlockType.pushLeft && j > indexColBallHere){
          moveTypeNextByPushTypeBlock = MoveType.left;
          break;
        }
        if(block.blockType == BlockType.telepot && j > indexColBallHere){
          _indexNextTelepotBlock = _indexRowColTelepotNext(iRow: indexRowBallHere, jCol: j);
          break;
        }
        if(block.blockType == BlockType.edgeTopRight){
          if(indexRowBallHere + 1 < _matrixTileMapShort.length){
            var block = matrixBlockForPlayGame[indexRowBallHere + 1][j];
            if(block != null){
              _saveIndexNextByEdgeBlock = [indexRowBallHere + 1,j];
            }
          }
          break;
        }
        if(block.blockType == BlockType.edgeBottomRight){
          if(indexRowBallHere - 1 >= 0){
            var block = matrixBlockForPlayGame[indexRowBallHere - 1][j];
            if(block != null){
              _saveIndexNextByEdgeBlock = [indexRowBallHere - 1,j];
            }
          }
          break;
        }
        if(block.blockType == BlockType.one){
          listIndexRowColBlockOne.add('$indexRowBallHere|$j');
        }
      } else {
        break;
      }
    }
  }
  void _runBallLeft(){
    listIndexRowColBlockOne.clear();
    for(int j = indexColBallHere;  j >= 0 ; j--){
      var block =  matrixBlockForPlayGame[indexRowBallHere][j];
      if(block != null){
        newIndexColBallInMove = j;
        block.isDrew = true;
        if(block.blockType == BlockType.bomb){
          curGameState.value = GameState.lose;
          break;
        }
        if(block.blockType == BlockType.magnet && j < indexColBallHere){
          break;
        }
        if(block.blockType == BlockType.pushTop && j < indexColBallHere){
          moveTypeNextByPushTypeBlock = MoveType.up;
          break;
        }
        if(block.blockType == BlockType.pushRight && j < indexColBallHere){
          moveTypeNextByPushTypeBlock = MoveType.right;
          break;
        }
        if(block.blockType == BlockType.pushBottom && j < indexColBallHere){
          moveTypeNextByPushTypeBlock = MoveType.down;
          break;
        }
        if(block.blockType == BlockType.pushLeft && j < indexColBallHere){
          moveTypeNextByPushTypeBlock = MoveType.left;
          break;
        }
        if(block.blockType == BlockType.telepot && j < indexColBallHere){
          _indexNextTelepotBlock = _indexRowColTelepotNext(iRow: indexRowBallHere, jCol: j);
          break;
        }
        if(block.blockType == BlockType.edgeTopLeft){
          if(indexRowBallHere + 1 < _matrixTileMapShort.length){
            var block = matrixBlockForPlayGame[indexRowBallHere + 1][j];
            if(block != null){
              _saveIndexNextByEdgeBlock = [indexRowBallHere + 1,j];
            }
          }
          break;
        }
        if(block.blockType == BlockType.edgeBottomLeft){
          if(indexRowBallHere - 1 >= 0){
            var block = matrixBlockForPlayGame[indexRowBallHere - 1][j];
            if(block != null){
              _saveIndexNextByEdgeBlock = [indexRowBallHere - 1,j];
            }
          }
          break;
        }
        if(block.blockType == BlockType.one){
          listIndexRowColBlockOne.add('$indexRowBallHere|$j');
        }
      } else {
        break;
      }
    }
  }
  bool isGameState(GameState gameState){
    return curGameState.value == gameState;
  }
  void runBallByPlayingNow() async{
    if(isGameState(GameState.lose)){
      showMessageToUserNowToast(GameState.lose.status);
      return;
    }
    if(moveType.value == MoveType.none){
      return;
    }
    _saveIndexNextByEdgeBlock = [-1,-1];
    _indexNextTelepotBlock = [-1,-1];
    moveTypeNextByPushTypeBlock = MoveType.none;
    newIndexRowBallInMove = indexRowBallHere;
    newIndexColBallInMove = indexColBallHere;
    switch(moveType.value){
      case MoveType.up:
        _runBallUp();
        break;
      case MoveType.down:
        _runBallDown();
        break;
      case MoveType.right:
        _runBallRight();
        break;
      case MoveType.left:
        _runBallLeft();
        break;
    }
    if(newIndexRowBallInMove != indexRowBallHere || newIndexColBallInMove != indexColBallHere){
      indexRowBallHere = newIndexRowBallInMove;
      indexColBallHere = newIndexColBallInMove;
      if(listIndexRowColBlockOne.isNotEmpty){
        for (var element in listIndexRowColBlockOne) {
          var iRow = int.parse(element.split('|')[0].trim());
          var iCol = int.parse(element.split('|')[1].trim());
          if(iRow != indexRowBallHere || iCol != indexColBallHere){
            matrixBlockForPlayGame[iRow][iCol] = null;
          }
        }
      }
      matrixBlockForPlayGame.refresh();
      _checkGamePlayingWin();
      if(isGameState(GameState.playing)){
        if(moveTypeNextByPushTypeBlock != MoveType.none){
          await Future.delayed(_durationAnimMove);
          moveType.value = moveTypeNextByPushTypeBlock;
          runBallByPlayingNow();
        } else if(_indexNextTelepotBlock.length == 2 && _indexNextTelepotBlock[0] >= 0 && _indexNextTelepotBlock[1] >= 0){
          var iRow = _indexNextTelepotBlock[0];
          var jCol = _indexNextTelepotBlock[1];
          if(iRow >= 0 && jCol >= 0){
            await Future.delayed(_durationAnimMove);
            var block = matrixBlockForPlayGame[iRow][jCol];
            if(block != null){
              block.isDrew = true;
              indexRowBallHere = iRow ;
              indexColBallHere = jCol;
              matrixBlockForPlayGame.refresh();
            }
          }
        } else if(_saveIndexNextByEdgeBlock.length == 2  && _saveIndexNextByEdgeBlock[0] >= 0 && _saveIndexNextByEdgeBlock[1] >= 0){
          var iRow = _saveIndexNextByEdgeBlock[0];
          var jCol = _saveIndexNextByEdgeBlock[1];
          if(iRow >= 0 && jCol >= 0){
            await Future.delayed(_durationAnimMove);
            var block = matrixBlockForPlayGame[iRow][jCol];
            if(block != null){
              block.isDrew = true;
              indexRowBallHere = iRow ;
              indexColBallHere = jCol;
              matrixBlockForPlayGame.refresh();
            }
          }
        }
      }
    }
  }
  void _checkGamePlayingWin(){
    bool isWinThisLevel = true;
    for(int i = 0; i < matrixBlockForPlayGame.length; i++){
      for(int j = 0; j < matrixBlockForPlayGame.first.length; j++){
        var block = matrixBlockForPlayGame[i][j];
        if(block != null && block!.blockType.isNoNeedPassIt){
          continue;
        }
        if(block != null && !block.isDrew){
          isWinThisLevel = false;
          break;
        }
      }
      if(!isWinThisLevel){
        break;
      }
    }
    if(isWinThisLevel){
      curGameState.value = GameState.win;
    }
  }

  void findDirectionMoveTypeByPlayingGame(){
    if(pointTouchDown == null || pointTouchUp == null){
      moveType.value = MoveType.none;
      return;
    }
    if((pointTouchUp! - pointTouchDown!).distance < sizeBlock){
      moveType.value = MoveType.none;
      return;
    }
    var deltaX = (pointTouchUp!.dx - pointTouchDown!.dx);
    var deltaY = (pointTouchUp!.dy - pointTouchDown!.dy);
    if(deltaY.abs() >= deltaX.abs()){
       if(deltaY < 0){
         moveType.value = MoveType.up;
       } else {
         moveType.value = MoveType.down;
       }
    } else {
      if(deltaX < 0){
        moveType.value = MoveType.left;
      } else {
        moveType.value = MoveType.right;
      }
    }
  }
  bool  isLevelHasTelepotBlockIsSatisfyCondition(){
    return _teleportManager.isTeleportCoupleIsSatisfy();
  }
  bool isCanPlayOrExportLevelGame(){
    var hasStartBlock = false;
    var hasAtleastBlock = false;
    for (int i = 0; i < matrixMaxRow; i++) {
      for (int j = 0; j < matrixMaxCol; j++) {
        if (matrixTileMap[i][j] == 0) {
          hasStartBlock = true;
        }
        if (matrixTileMap[i][j] > 0) {
          hasAtleastBlock = true;
        }
        if(hasStartBlock && hasAtleastBlock){
          break;
        }
      }
      if(hasStartBlock && hasAtleastBlock){
        break;
      }
    }
    return hasStartBlock && hasAtleastBlock;
  }
  void _removeIndexJITeleportCouple({required int iRow, required int jCol}){
    var offsetCouple = _teleportManager.removeIndexJITeleport(iRow: iRow, jCol: jCol);
    if(offsetCouple != null){
      var indexI = offsetCouple[0];
      var indexJ = offsetCouple[1];
      if(matrixTileMap[indexI][indexJ] == BlockType.telepot.index){
        matrixTileMap[indexI][indexJ] = -1;
        _teleportManager.removeIndexJITeleport(iRow: iRow, jCol: jCol);
      }
    }
  }

  bool isMatrixTileMapIsEmpty() {
    for (int i = 0; i < matrixMaxRow; i++) {
      for (int j = 0; j < matrixMaxCol; j++) {
        if (matrixTileMap[i][j] >= 0) {
          return false;
        }
      }
    }// tested, it fast: matrix: 16x20 -> 320 block, just <= 1 milliseconds
    return true;
  }

  void clearAllTileMapWorking() {
    drawAreaCells.clear();
    for (int i = 0; i < matrixMaxRow; i++) {
      for (int j = 0; j < matrixMaxCol; j++) {
        matrixTileMap[i][j] = -1;
      }
    }
    refreshUIByRefreshMatrixTileMap();
    _teleportManager.clear();
  }

  Block blockByBlockTool(BlockTool blockTool) => blockList
      .where((element) => element.blockType == blockTool.blockType)
      .first;

  void _setBlockToolSelected(BlockTool blockTool){
    if(blockTool.blockType != blockToolSelected?.blockType){
      blockToolSelected = blockTool;
    }
  }
  void setStartBlockToolChoose() {
    for (var element in blockToolList.value) {
      element.isChoose = false;
    }
    startBlockTool.value.isChoose = true;
    _setBlockToolSelected(startBlockTool.value);
    startBlockTool.refresh();
    blockToolList.refresh();
    if(featureTool.value != FeatureTool.area){
      featureTool.value = FeatureTool.area;
    }
  }

  void setBlockToolChoose(BlockTool blockTool) {
    if(startBlockTool.value.isChoose){
      startBlockTool.value.isChoose = false;
      startBlockTool.refresh();
    }
    for (var element in blockToolList.value) {
      element.isChoose = false;
    }
    blockTool.isChoose = true;
    _setBlockToolSelected(blockTool);
    blockToolList.refresh();
    if(featureTool.value != FeatureTool.area){
      featureTool.value = FeatureTool.area;
    }
  }

  bool isAcceptBlockToolToCellTilemap(BlockTool? blockTool, int index) {
    if (blockTool == null) {
      return false;
    }
    int i = (index / matrixMaxCol).floor();
    int j = index % matrixMaxCol;
    if(matrixTileMap[i][j] == blockTool.blockType.index){
      return false;
    }
    if (blockTool.blockType == BlockType.start) {
      return startBlockTool.value.isChoose;
    }
    return blockTool.isChoose;
  }

  void refreshMatrixTileMapShort() {
    _matrixTileMapShort = _calculateMatrixTileMapShort();
    _matrixTileMapShort;

  }
  int indexRowBallHere = 0, indexColBallHere = 0;
  int newIndexRowBallInMove = 0, newIndexColBallInMove = 0;
  int indexBallPlayInGamePlay(){
    return indexInGridCellGamePlay(indexRow: indexRowBallHere, indexCol: indexColBallHere);
  }
  int indexInGridCellGamePlay({required int indexRow, required int indexCol}){
    return indexRow * _matrixTileMapShort.first.length + indexCol;
  }
  void replayThisGameTest(){
    moveType.value = MoveType.none;
    curGameState.value = GameState.playing;
    refreshMatrixTileMapShortAndInitForPlayGame();
  }
  void refreshMatrixTileMapShortAndInitForPlayGame(){
    refreshMatrixTileMapShort();
    var matrix = _matrixTileMapShort;
    if(matrix.isEmpty){
      return;
    }
    int nRow = matrix.length;
    int nCol = matrix.first.length;
    matrixBlockForPlayGame.value = List.generate(
      nRow,
          (i) => List.generate(nCol, (j) => null),
    );
    for(int i = 0; i < nRow; i++){
      for(int j = 0; j < nCol; j++){
        var idBlock = matrix[i][j];
        if(idBlock< 0){
          matrixBlockForPlayGame[i][j] = null;
        } else {
          var block = blockList.firstWhere((element) => element.blockType.index == idBlock).clone();
          if(block.blockType == BlockType.start){
            indexRowBallHere = i;
            indexColBallHere = j;
          }
          matrixBlockForPlayGame[i][j] = block;
        }
      }
    }
    matrixBlockForPlayGame.refresh();
  }
  String? idTeleportCoupleShortTileMapGame(Block? block, index){
    if(block == null) {
      return null;
    }
    String? idCoupleTelepot;
    if(block.blockType == BlockType.telepot){
      var matrixCol = _matrixTileMapShort.first.length;
      int i = (index / matrixCol).floor();
      int j = index % matrixCol;
      idCoupleTelepot = _teleportManager.findIdCoupleOfTeleport(iRow: i, jCol: j, getFromShortList: true);
    }
    return idCoupleTelepot;
  }
  String? idTeleportCoupleFullTileMap(Block? block, index){
    if(block == null) {
      return null;
    }
    String? idCoupleTelepot;
    if(block.blockType == BlockType.telepot){
      int i = (index / matrixMaxCol).floor();
      int j = index % matrixMaxCol;
      idCoupleTelepot = _teleportManager.findIdCoupleOfTeleport(iRow: i, jCol: j, getFromShortList: false);
    }
    return idCoupleTelepot;
  }

  List<List<int>> _calculateMatrixTileMapShort() {
    var org = matrixTileMap;
    int minRow = -1, maxRow = -1;
    int minCol = -1, maxCol = -1;
    for (int i = 0; i < org.length; i++) {
      for (int j = 0; j < org[i].length; j++) {
        if (org[i][j] >= 0) {
          if (minRow < 0 || i < minRow) {
            minRow = i;
          }
          if (maxRow < 0 || i > maxRow) {
            maxRow = i;
          }
          if (minCol < 0 || j < minCol) {
            minCol = j;
          }
          if (maxCol < 0 || j > maxCol) {
            maxCol = j;
          }
        }
      }
    }
    if (minRow < 0 || maxRow < 0 || minCol < 0 || maxCol < 0) {
      return [];
    }
    var newMatrixRow = maxRow - minRow + 1;
    var newMatrixCol = maxCol - minCol + 1;
    _teleportManager.updateListTeleportBlocksCoupleShort(deltaRow: minRow, deltaCol: minCol);
    var result = List.generate(
      newMatrixRow,
      (i) => List.generate(newMatrixCol, (j) => -1),
    );
    for (int i = 0; i < result.length; i++) {
      for (int j = 0; j < result[i].length; j++) {
        result[i][j] = org[i + minRow][j + minCol];
      }
    }
    return result;
  }

  String dataLevelExport() {
    refreshMatrixTileMapShort();
    var full = matrixTileMap;
    var short = _matrixTileMapShort;
    var result = jsonEncode(DataExport(short: short, full: full,
        teleportCoupleFull: _teleportManager.listTeleportBlocksCouple, teleportCoupleShort: _teleportManager.listTeleportBlocksCoupleShort).toJson());
    return result;
  }

  void importDataFromFileLevel(String data){
    var valueMap = json.decode(data);
    var full = jsonDecode(valueMap["full"]);
    moveType.value = MoveType.none;
    featureTool.value = FeatureTool.none;
    clearAllTileMapWorking();
    for(int i = 0; i < (full as List<dynamic>).length; i++){
      var list = List<int>.from(full[i]);
      for(int j = 0; j < list.length; j++){
        if(i < matrixMaxRow && j < matrixMaxCol){
          matrixTileMap[i][j] = list[j];
        }
      }
    }
    var teleFull = <String>[];
    for(var data in jsonDecode(valueMap["teleportCoupleFull"])){
      teleFull.add(data.toString());
    }
    _teleportManager.setListTeleportBlocksCoupleByImportFileData(teleFull);
    refreshUIByRefreshMatrixTileMap();
  }
}
