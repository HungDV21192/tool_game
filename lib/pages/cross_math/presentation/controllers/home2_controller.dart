import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tool_eat_all_game/pages/cross_math/domain/entity/cell_number.dart';
import 'package:tool_eat_all_game/pages/cross_math/presentation/views/button_bottom_view.dart';
import 'package:tool_eat_all_game/pages/cross_math/presentation/views/map_number_view.dart';
import 'package:tool_eat_all_game/utils/constants.dart';

class Home2Controller extends GetxController {
  Home2Controller();

  final RxList<String> numberTopList = [""].obs;
  final RxInt numberIndexTopSelect = (-1).obs;
  final RxList<int> numberBottomList = [none_number].obs;
  final RxInt numberIndexBottomSelect = (-1).obs;
  final RxString numbersBoardInput = ''.obs;
  final RxString dataLevelOutPut = ''.obs;
  final Rx<HashMap<int, int>> mapNumberCorrectFilled = HashMap<int, int>().obs;
  @override
  void onInit() {
    super.onInit();
    reset();
  }

  void reset() {
    isShowEmptyCell.value = true;
    isCongTruNhanChiaBang.value = true;
    numbersBoardInput.value = "";
    numberIndexBottomSelect.value = -1;
    numberIndexTopSelect.value = -1;
    autoNextCellBottomNumber100.value = false;
    numberBottomList.clear();
    dataLevelOutPut.value = '';
    for (int i = 0; i < 28; i++) {
      numberBottomList.value.add(none_number);
    }
    numberTopList.value.clear();
    for (int i = 0; i < matrixMaxRow * matrixMaxCol; i++) {
      numberTopList.value.add(noneTileCellText);
    }
    listCellNumber.clear();
    numberBottomListFilled.clear();
    mapNumberCorrectFilled.value.clear();
    numberTopList.refresh();
    numberBottomList.refresh();
    numberClickBottomChoosed = none_number;
    timer?.cancel();
    timer = null;
    messeageAction.value = "";
    isNotSuggessCheck.value = true;
  }

  NumberType numberTypeByText(String text) {
    var type = NumberType.None;
    if (text == noneTileCellText) {
      type = NumberType.None;
    } else if (text == emptyCellText) {
      type = NumberType.Empty;
    } else if (text == "+") {
      type = NumberType.Cong;
    } else if (text == "-") {
      type = NumberType.Tru;
    } else if (text == PhepNhanText) {
      type = NumberType.Nhan;
    } else if (text == PhepChiaText) {
      type = NumberType.Chia;
    } else {
      type = NumberType.Number;
    }
    return type;
  }

  TextEditingController textController = TextEditingController();
  int countCell = 0;
  List<CellNumber> listCellNumber = [];
  List<int> numberBottomListFilled = [];
  void GiaiLevel() {
    if (numberTopList.value
            .where((element) =>
                element != noneTileCellText && element != emptyCellText)
            .length <
        5) {
      showMessageToUserNow('Chưa nhập top list phép toán');
      return;
    }
    if (numberBottomList.value.where((element) => element >= 0).length < 2) {
      showMessageToUserNow('Chưa nhập top list bottom number');
      return;
    }
    playSoundButtonClick();
    listCellNumber.clear();
    numberBottomListFilled.clear();
    // x = i % matrixMaxCol, y = i / matrixMaxRow
    countCell = numberTopList.value
        .where((element) => element != noneTileCellText)
        .toList()
        .length;
    for (int i = 0; i < numberTopList.value.length; i++) {
      var text = numberTopList.value[i];
      if (text != noneTileCellText) {
        var x = i % matrixMaxCol;
        var y = i ~/ matrixMaxCol;
        listCellNumber.add(CellNumber(
            x: x, y: y, numberType: numberTypeByText(text), text: text));
      }
    }

    var countBottomNumber = numberBottomList.value
        .where((element) => element != none_number)
        .toList()
        .length;
    for (int i = 0; i < numberBottomList.value.length; i++) {
      if (numberBottomList.value[i] != none_number) {
        numberBottomListFilled.add(numberBottomList.value[i]);
      }
      if (numberBottomListFilled.length >= countBottomNumber) {
        break;
      }
    }
    orgFirstCellNumberList = cloneList(listCellNumber);
    _exportDataLevel();
    _findCauDoAndResolveCurrentTry = 0;
    _findCauDoAndResolveMaxTry = emptyCellList(listCellNumber).length + 1;
    lastCellNotYetFilledCount = -1;
    mapNumberIndexMaybeTryPhepThu.clear();
    _findCauDoAndResolve2();
  }

  List<CellNumber> orgFirstCellNumberList  = [];
  void exportDataLevelBeforeCopy(){
    _exportDataLevel();
  }
  void checkSaveNumberClickBottomChoosed() {
      numberClickBottomChoosed =
          numberBottomList.value[numberIndexBottomSelect.value];
  }

  void BACKLai() {
    if(numberIndexTopSelect.value >= 0){
      if(mapNumberCorrectFilled.value.containsKey(numberIndexTopSelect.value)){
        var number = mapNumberCorrectFilled.value[numberIndexTopSelect.value];
        mapNumberCorrectFilled.value.remove(numberIndexTopSelect.value);
        var isBacked = false;
        for(int i = 0; i < numberBottomList.value.length; i++){
          if(numberBottomList.value[i] == none_number){
            numberBottomList.value[i] = number!;
            isBacked = true;
            break;
          }
        }
        if(!isBacked){
          numberBottomList.value.add(number!);
          isBacked = true;
        }
        var x = numberIndexTopSelect.value % matrixMaxCol;
        var y = numberIndexTopSelect.value ~/ matrixMaxCol;
        var cellFind = findCellByXY(x, y, listCellNumber);
        cellFind?.numberType = NumberType.Empty;
        cellFind?.text = emptyCellText;
        mapNumberCorrectFilled.refresh();
        numberBottomList.refresh();
      }
    }
  }
  int numberClickBottomChoosed = none_number;
  void GiaiTiep() {
    if (
        numberClickBottomChoosed != none_number &&
        numberIndexTopSelect.value >= 0) {
      var x = numberIndexTopSelect.value % matrixMaxCol;
      var y = numberIndexTopSelect.value ~/ matrixMaxCol;
      if (numberIndexTopSelect.value >= 0) {
        mapNumberCorrectFilled.value[numberIndexTopSelect.value] =
            numberClickBottomChoosed;
        numberBottomList.value.remove(numberClickBottomChoosed);
        var cellFind = findCellByXY(x, y, listCellNumber);
        cellFind?.numberType = NumberType.Number;
        cellFind?.text = numberClickBottomChoosed.toString();
        mapNumberCorrectFilled.refresh();
        numberBottomList.refresh();
      }
      _findCauDoAndResolveCurrentTry -= 3;
      _findCauDoAndResolve2();
    } else {
      showMessageToUserNow("Chưa chọn số và ô để giải tiếp!");
    }
  }

  HashMap<int, List<int>> mapNumberIndexMaybeTryPhepThu =
      HashMap<int, List<int>>();
  void _tryPhepThuCheckCaudoResolve3() {
    mapNumberIndexMaybeTryPhepThu.clear();
    List<List<CellNumber>> listQuests = listQuestsInTitleMap();
    for (var quests in listQuests) {
      var emptyCells = emptyCellList(quests);
      if (emptyCells.length == 2) {
        var orgLeft = MathExpress(quests, isMathLeftBang: true);
        var orgRight = MathExpress(quests, isMathLeftBang: false);
        for (int i = 0; i < numberBottomList.value.length; i++) {
          for (int j = 0; j < numberBottomList.value.length; j++) {
            var numberI = numberBottomList.value[i];
            var numberJ = numberBottomList.value[j];
            if (j == i || numberI == none_number || numberJ == none_number) {
              continue;
            }
            var leftMat = orgLeft;
            var rightMath = orgRight;
            var isReplaceNumberI = false;
            var isReplaceNumberJ = false;
            if(leftMat.contains(emptyCellText) && !isReplaceNumberI){
              leftMat = leftMat.replaceFirst(emptyCellText, numberI.toString());
              isReplaceNumberI = true;
            }
            if(leftMat.contains(emptyCellText) && !isReplaceNumberJ){
              leftMat = leftMat.replaceFirst(emptyCellText, numberJ.toString());
              isReplaceNumberJ = true;
            }
            if(rightMath.contains(emptyCellText) && !isReplaceNumberI){
              rightMath = rightMath.replaceFirst(emptyCellText, numberI.toString());
              isReplaceNumberI = true;
            }
            if(rightMath.contains(emptyCellText) && !isReplaceNumberJ){
              rightMath = rightMath.replaceFirst(emptyCellText, numberJ.toString());
              isReplaceNumberJ = true;
            }
            var isCorrectAnswer =
            (leftMat.interpret() == rightMath.interpret());
            if (isCorrectAnswer) {
              List<int> listI = mapNumberIndexMaybeTryPhepThu[numberI] ?? [];
              if (!listI.contains(emptyCells[0].idInTileMap)) {
                listI.add(emptyCells[0].idInTileMap);
                mapNumberIndexMaybeTryPhepThu[numberI] = listI;
              }
              List<int> listJ = mapNumberIndexMaybeTryPhepThu[numberJ] ?? [];
              if (!listJ.contains(emptyCells[1].idInTileMap)) {
                listJ.add(emptyCells[1].idInTileMap);
                mapNumberIndexMaybeTryPhepThu[numberJ] = listJ;
              }
            }
          }
        }
      }
    }
    // duyet has map
    bool isOkCanFilled = false;
    for (var entry in mapNumberIndexMaybeTryPhepThu.entries) {
      if(entry.value.length == 1){
        var cell = listCellNumber.where((element) => element.idInTileMap == entry.value[0]);
        if(cell.isNotEmpty){
          fillCorrectNumberToLevelMap(cell!.first, entry.key);
          isOkCanFilled = true;
        }
      }
    }
    if (isOkCanFilled) {
      _findCauDoAndResolveCurrentTry--;
      _findCauDoAndResolve2();
    } else {
      // show log for checking
      for (var entry in mapNumberIndexMaybeTryPhepThu.entries) {
        if(entry.value.length == 2){
          print('HAO_BK_PRO_2_POS: ${entry.key}, Value: ${jsonEncode(entry.value)} |${logIdXYInTitleMap(entry.value[0])}|${logIdXYInTitleMap(entry.value[1])}');
        }
      }
    }
  }
  String logIdXYInTitleMap(int id){
    var x = id % matrixMaxCol;
    var y = id ~/ matrixMaxCol;
    return '|x,y: $x,$y|';
  }

  List<List<CellNumber>> listQuestsInTitleMap() {
    int minX =
        listCellNumber.map((obj) => obj.x).reduce((a, b) => a < b ? a : b);
    int maxX =
        listCellNumber.map((obj) => obj.x).reduce((a, b) => a > b ? a : b);
    int minY =
        listCellNumber.map((obj) => obj.y).reduce((a, b) => a < b ? a : b);
    int maxY =
        listCellNumber.map((obj) => obj.y).reduce((a, b) => a > b ? a : b);
    // tìm ra câu đố  toán theo trục x (ngang)
    List<List<CellNumber>> listQuests = [];
    for (int y = minY; y <= maxY; y++) {
      List<CellNumber> questX = [];
      for (int x = minX; x <= maxX; x++) {
        var cell = findCellByXY(x, y, listCellNumber);
        if (cell != null) {
          questX.add(cell);
          if (x == maxX && isQuestMath(questX)) {
            listQuests.add(cloneList(questX));
          }
        } else {
          if (isQuestMath(questX)) {
            listQuests.add(cloneList(questX));
          }
          questX.clear();
        }
      }
    }
    // tìm ra câu đố  toán theo trục y (dọc)
    for (int x = minX; x <= maxX; x++) {
      List<CellNumber> questY = [];
      for (int y = minY; y <= maxY; y++) {
        var cell = findCellByXY(x, y, listCellNumber);
        if (cell != null) {
          questY.add(cell);
          if (y == maxY && isQuestMath(questY)) {
            listQuests.add(cloneList(questY));
          }
        } else {
          if (isQuestMath(questY)) {
            listQuests.add(cloneList(questY));
          }
          questY.clear();
        }
      }
    }
    return listQuests;
  }

  void _findCauDoAndResolve2() {
    if (_findCauDoAndResolveCurrentTry > _findCauDoAndResolveMaxTry) {
      return;
    }
    // tìm ra câu đố  toán theo trục x (ngang)
    List<List<CellNumber>> listQuests = listQuestsInTitleMap();
    for (var quests in listQuests) {
      var emptyCells = emptyCellList(quests);
      // có 1 số hạng chưa được điền (case dễ nhất)
      if (emptyCells.length == 1) {
        var orgLeft = MathExpress(quests, isMathLeftBang: true);
        var orgRight = MathExpress(quests, isMathLeftBang: false);
        int numberCorrect = none_number;
        for (var numberBottom in numberBottomList.value) {
          if (numberBottom != none_number) {
            var leftMat =
                orgLeft.replaceFirst(emptyCellText, numberBottom.toString());
            var rightMath =
                orgRight.replaceFirst(emptyCellText, numberBottom.toString());
            var isCorrectAnswer =
                (leftMat.interpret() == rightMath.interpret());
            if (isCorrectAnswer) {
              numberCorrect = numberBottom;
              break;
            }
          }
        }
        if (numberCorrect != none_number) {
          fillCorrectNumberToLevelMap(emptyCells.first, numberCorrect);
        }
      } else if (emptyCells.length == 2) {
        var orgLeft = MathExpress(quests, isMathLeftBang: true);
        var orgRight = MathExpress(quests, isMathLeftBang: false);
        int numberCorrect1 = none_number;
        int numberCorrect2 = none_number;
        var hasManyAnswerMaybeCorrect = false;
        for (int i = 0; i < numberBottomList.value.length; i++) {
          for (int j = 0; j < numberBottomList.value.length; j++) {
            var numI = numberBottomList.value[i];
            var numJ = numberBottomList.value[j];
            bool alreadyFillNumI = false;
            bool alreadyFillNumJ = false;
            if (j != i && numI != none_number && numJ != none_number) {
              var leftMat = orgLeft;
              var rightMath = orgRight;
              if (orgLeft.contains(emptyCellText)) {
                leftMat = orgLeft.replaceFirst(emptyCellText, numI.toString());
                alreadyFillNumI = true;
                if (leftMat.contains(emptyCellText)) {
                  leftMat =
                      leftMat.replaceFirst(emptyCellText, numJ.toString());
                  alreadyFillNumJ = true;
                }
              }
              if (!alreadyFillNumI) {
                rightMath =
                    orgRight.replaceFirst(emptyCellText, numI.toString());
                alreadyFillNumI = true;
              }
              if (!alreadyFillNumJ) {
                rightMath =
                    rightMath.replaceFirst(emptyCellText, numJ.toString());
                alreadyFillNumJ = true;
              }
              var isCorrectAnswer =
                  (leftMat.interpret() == rightMath.interpret());
              if (isCorrectAnswer) {
                if (numberCorrect1 == none_number) {
                  numberCorrect1 = numI;
                  numberCorrect2 = numJ;
                } else {
                  if (numberCorrect1 != numI) {
                    numberCorrect1 = none_number;
                    numberCorrect2 = none_number;
                    hasManyAnswerMaybeCorrect = true;
                    break;
                  }
                }
              }
            }
          }
          if (hasManyAnswerMaybeCorrect) {
            break;
          }
        }
        if (numberCorrect1 != none_number &&
            numberCorrect2 != none_number &&
            !hasManyAnswerMaybeCorrect) {
          fillCorrectNumberToLevelMap(emptyCells[0], numberCorrect1);
          fillCorrectNumberToLevelMap(emptyCells[1], numberCorrect2);
        }
      } else if (emptyCells.length == 3) {
        var orgLeft = MathExpress(quests, isMathLeftBang: true);
        var orgRight = MathExpress(quests, isMathLeftBang: false);
        int numberCorrect1 = none_number;
        int numberCorrect2 = none_number;
        int numberCorrect3 = none_number;
        var hasManyAnswerMaybeCorrect = false;
        for (int i = 0; i < numberBottomList.value.length; i++) {
          for (int j = 0; j < numberBottomList.value.length; j++) {
            if(j == i){
              continue;
            }
            for (int k = 0; k < numberBottomList.value.length; k++) {
              var numI = numberBottomList.value[i];
              var numJ = numberBottomList.value[j];
              var numK = numberBottomList.value[k];
              if(i == j || j == k || i == k || numI == none_number || numJ == none_number || numK == none_number){
                continue;
              }
              bool isReplaceNumI = false, isReplaceNumJ = false, isReplaceNumK = false;
              var leftMat = orgLeft;
              var rightMath = orgRight;
              if(leftMat.contains(emptyCellText) && !isReplaceNumI){
                leftMat =
                    leftMat.replaceFirst(emptyCellText, numI.toString());
                isReplaceNumI = true;
              }
              if(leftMat.contains(emptyCellText) && !isReplaceNumJ){
                leftMat =
                    leftMat.replaceFirst(emptyCellText, numJ.toString());
                isReplaceNumJ = true;
              }
              if(leftMat.contains(emptyCellText) && !isReplaceNumK){
                leftMat =
                    leftMat.replaceFirst(emptyCellText, numK.toString());
                isReplaceNumK = true;
              }
              if(rightMath.contains(emptyCellText) && !isReplaceNumI){
                rightMath =
                    rightMath.replaceFirst(emptyCellText, numI.toString());
                isReplaceNumI = true;
              }
              if(rightMath.contains(emptyCellText) && !isReplaceNumJ){
                rightMath =
                    rightMath.replaceFirst(emptyCellText, numJ.toString());
                isReplaceNumJ = true;
              }
              if(rightMath.contains(emptyCellText) && !isReplaceNumK){
                rightMath =
                    rightMath.replaceFirst(emptyCellText, numK.toString());
                isReplaceNumK = true;
              }
              var isCorrectAnswer =
              (leftMat.interpret() == rightMath.interpret());
              if (isCorrectAnswer) {
                if (numberCorrect1 == none_number) {
                  numberCorrect1 = numI;
                  numberCorrect2 = numJ;
                  numberCorrect3 = numK;
                } else {
                  if (numberCorrect1 != numI && numberCorrect2 != numJ) {
                    numberCorrect1 = none_number;
                    numberCorrect2 = none_number;
                    numberCorrect3 = none_number;
                    hasManyAnswerMaybeCorrect = true;
                    break;
                  }
                }
              }
            }
            if (hasManyAnswerMaybeCorrect) {
              break;
            }
          }
          if (hasManyAnswerMaybeCorrect) {
            break;
          }
        }
        if (numberCorrect1 != none_number &&
            numberCorrect2 != none_number &&
            !hasManyAnswerMaybeCorrect) {
          fillCorrectNumberToLevelMap(emptyCells[0], numberCorrect1);
          fillCorrectNumberToLevelMap(emptyCells[1], numberCorrect2);
          fillCorrectNumberToLevelMap(emptyCells[2], numberCorrect3);
        }
      }
    }
    if (isLevelCompltedFilled) {
      showMessageToUserNow("Level này giải được", timeHide: 9);
      _exportDataLevel();
    } else {
      _findCauDoAndResolveCurrentTry++;
      var currentCellNotYetFilledCount = listCellNumber
          .where((cell) => cell.numberType == NumberType.Empty)
          .length;
      if (lastCellNotYetFilledCount <= 0 ||
          currentCellNotYetFilledCount != lastCellNotYetFilledCount) {
        lastCellNotYetFilledCount = currentCellNotYetFilledCount;
        _findCauDoAndResolve2();
      } else if(!isNotSuggessCheck.value){
        _tryPhepThuCheckCaudoResolve3();
      }
    }
  }

  int lastCellNotYetFilledCount = -1;
  void fillCorrectNumberToLevelMap(CellNumber cell, int numberCorrect) {
    mapNumberCorrectFilled.value[cell.idInTileMap] = numberCorrect;
    numberBottomList.value.remove(numberCorrect);
    var cellFind = findCellByXY(cell.x, cell.y, listCellNumber);
    cellFind?.numberType = NumberType.Number;
    cellFind?.text = numberCorrect.toString();
    mapNumberCorrectFilled.refresh();
    numberBottomList.refresh();
  }

  List<CellNumber> emptyCellList(List<CellNumber> quests) {
    List<CellNumber> result = [];
    for (var cell in quests) {
      if (cell.text == emptyCellText) {
        if (!mapNumberCorrectFilled.value.containsKey(cell.idInTileMap) ||
            mapNumberCorrectFilled.value[cell.idInTileMap] == none_number) {
          result.add(cell);
        }
      }
    }
    return result;
  }

  String MathExpress(List<CellNumber> quests, {required bool isMathLeftBang}) {
    var indexBang = 0;
    for (int i = 0; i < quests.length; i++) {
      if (quests[i].text == '=') {
        indexBang = i;
        break;
      }
    }
    if (isMathLeftBang) {
      String mathLeft = "";
      for (int i = 0; i < indexBang; i++) {
        var text = quests[i].text.trim();
        if (mapNumberCorrectFilled.value.containsKey(quests[i].idInTileMap)) {
          text = mapNumberCorrectFilled.value[quests[i].idInTileMap].toString();
        } else {
          if (text == PhepChiaText) {
            text = "/";
          } else if (text == PhepNhanText) {
            text = "*";
          }
        }
        mathLeft += text;
      }
      return mathLeft;
    } else {
      String mathRight = "";
      for (int i = indexBang + 1; i < quests.length; i++) {
        var text = quests[i].text.trim();
        if (mapNumberCorrectFilled.value.containsKey(quests[i].idInTileMap)) {
          text = mapNumberCorrectFilled.value[quests[i].idInTileMap].toString();
        } else {
          if (text == PhepChiaText) {
            text = "/";
          } else if (text == PhepNhanText) {
            text = "*";
          }
        }
        mathRight += text;
      }
      return mathRight;
    }
  }

  int _findCauDoAndResolveMaxTry = 0;
  int _findCauDoAndResolveCurrentTry = 0;
  void _exportDataLevel() {
    var listCellLevel = orgFirstCellNumberList;
    int minX =
        listCellLevel.map((obj) => obj.x).reduce((a, b) => a < b ? a : b);
    int minY =
        listCellLevel.map((obj) => obj.y).reduce((a, b) => a < b ? a : b);
    for (int i = 0; i < listCellLevel.length; i++) {
      listCellLevel[i].x -= minX;
      listCellLevel[i].y -= minY;
    }
    var dataLevel = '';
    for (int i = 0; i < listCellLevel.length; i++) {
      var cell = listCellLevel[i];
      var dataCellId = '${cell.x},${cell.y},${cell.text}';
      if(cell.text == emptyCellText && mapNumberCorrectFilled.value[cell.idInTileMap] != null && mapNumberCorrectFilled.value[cell.idInTileMap] != none_number){
        dataCellId+= ',${mapNumberCorrectFilled.value[cell.idInTileMap]}';
      }
      dataLevel = '$dataLevel$dataCellId|';
    }
    var numberBottoms = '';
    for (int i = 0; i < numberBottomListFilled.length - 1; i++) {
      numberBottoms = '$numberBottoms${numberBottomListFilled[i]},';
    }
    numberBottoms =
        '$numberBottoms${numberBottomListFilled[numberBottomListFilled.length - 1]}';
    dataLevel = '$dataLevel${numberBottoms}_HDV';
    dataLevelOutPut.value = dataLevel;
  }
  final isNotSuggessCheck = true.obs;
  final isSoundEffectEnable = true.obs;
  final audioPlayer = AudioPlayer();
  void _playSoundsGame(String soundFile) async {
    if (true != isSoundEffectEnable.value) return;
    try {
      await audioPlayer.setAsset('assets/$soundFile');
      audioPlayer.play();
    } catch (e) {}
  }

  void playSoundButtonClick() {
    _playSoundsGame('number_click.mp3');
  }

  bool get isLevelCompltedFilled => listCellNumber
      .where((cell) => cell.numberType == NumberType.Empty)
      .isEmpty;
  void refreshBottomNumberListAfterFilled() {
    var listNumberFilled = mapNumberCorrectFilled.value.values.toList();
    for (var number in listNumberFilled) {
      var first =
          numberBottomList.value.firstWhere((element) => number == element);
      if (first != null) {
        numberBottomList.value.remove(first);
      }
    }
    numberBottomList.refresh();
  }

  bool isNumber(String text) {
    return text != '+' &&
        text != '-' &&
        text != PhepNhanText &&
        text != PhepChiaText &&
        text != '=';
  }

  String logListNumber(List<CellNumber> list) {
    var result = '';
    for (var cell in list) {
      result += '${cell.text}';
    }
    return result;
  }

  bool IsCorrectAnswer(List<String> texts) {
    var indexBang = 0;
    for (var text in texts) {
      if (text == '=') {
        indexBang = texts.indexOf(text);
        break;
      }
    }
    String mathLeft = "";
    String mathRight = "";
    for (int i = 0; i < indexBang; i++) {
      var text = texts[i].trim();
      if (text == PhepChiaText) {
        text = "/";
      } else if (text == PhepNhanText) {
        text = "*";
      }
      mathLeft += text;
    }
    for (int i = indexBang + 1; i < texts.length; i++) {
      var text = texts[i].trim();
      if (text == PhepChiaText) {
        text = "/";
      } else if (text == PhepNhanText) {
        text = "*";
      }
      mathRight += text;
    }
    var result = (mathLeft.interpret() == mathRight.interpret());
    return result;
  }

  List<CellNumber> cloneList(List<CellNumber> list) {
    List<CellNumber> result = [];
    for (var cell in list) {
      result.add(CellNumber(
          x: cell.x, y: cell.y, numberType: cell.numberType, text: cell.text));
    }
    return result;
  }

  bool isQuestMath(List<CellNumber> questX) =>
      questX.length >= 5; // ít nhất 2 số công trừ nhân chia với nhau
  CellNumber? findCellByXY(int x, int y, List<CellNumber> list) {
    for (var cell in list) {
      if (cell.x == x && cell.y == y) {
        return cell;
      }
    }
    return null;
  }

  void inputTopNumber(NumberType numberType, {int number = 0}) {
    playSoundButtonClick();
    if (numberType == NumberType.None) {
      numberTopList.value[numberIndexTopSelect.value] = noneTileCellText;
      numbersBoardInput.value = "";
    } else if (numberType == NumberType.Empty) {
      numberTopList.value[numberIndexTopSelect.value] = emptyCellText;
    } else if (numberType == NumberType.Cong) {
      numberTopList.value[numberIndexTopSelect.value] = "+";
    } else if (numberType == NumberType.Tru) {
      numberTopList.value[numberIndexTopSelect.value] = "-";
    } else if (numberType == NumberType.Nhan) {
      numberTopList.value[numberIndexTopSelect.value] = PhepNhanText;
    } else if (numberType == NumberType.Chia) {
      numberTopList.value[numberIndexTopSelect.value] = PhepChiaText;
    } else if (numberType == NumberType.Bang) {
      numberTopList.value[numberIndexTopSelect.value] = '=';
    } else if (numberType == NumberType.Number) {
      numberTopList.value[numberIndexTopSelect.value] = number.toString();
    }
    numberTopList.refresh();
  }

  Timer? timer = null;
  void showMessageToUserNow(String text, {int timeHide = 2}) {
    if(timer != null){
      timer?.cancel();
      timer = null;
    }
    messeageAction.value = text.trim();
    timer = Timer(Duration(seconds: timeHide), () {
      messeageAction.value = '';
    });
  }

  void CheckSugressQuest(){
    if((dataLevelOutPut.value.isNotEmpty && !isLevelCompltedFilled && numberIndexTopSelect.value >= 0)){
      List<List<CellNumber>> listQuests = listQuestsInTitleMap();
      var message = "";
      for(var quests in listQuests){
        if(quests.where((cell) => cell.idInTileMap == numberIndexTopSelect.value).isNotEmpty){
          var list = suggressOfQuests(quests);
          if(list.length >= 6){
            list = list.sublist(0, 6);
          }
          var log = "${logListNumber(quests)} | ${jsonEncode(list)}";
          print("HAO_CHECK_QUES: ${log}");
          message = "${message}\n$log";
        }
      }
      if(message.isNotEmpty){
       showMessageToUserNow(message, timeHide: 60);
      }
    }
  }
  List<List<int>> suggressOfQuests(List<CellNumber> quests){
    List<List<int>> result = [];
    var emptyCells = emptyCellList(quests);
    var orgLeft = MathExpress(quests, isMathLeftBang: true);
    var orgRight = MathExpress(quests, isMathLeftBang: false);
    if(emptyCells.length == 2){
      for(int i = 0; i < numberBottomList.value.length; i++){
        for(int j = 0; j < numberBottomList.value.length; j++){
          var numI = numberBottomList.value[i];
          var numJ = numberBottomList.value[j];
          if(j == i || numI == none_number || numJ == none_number)continue;
          var isFilledNumI = false, isFilledNumJ = false;
          var mathLeft = orgLeft;
          var mathRight = orgRight;
          if(mathLeft.contains(emptyCellText) && !isFilledNumI){
            mathLeft = mathLeft.replaceFirst(emptyCellText, numI.toString());
            isFilledNumI = true;
          }
          if(mathLeft.contains(emptyCellText) && !isFilledNumJ){
            mathLeft = mathLeft.replaceFirst(emptyCellText, numJ.toString());
            isFilledNumJ = true;
          }
          if(mathRight.contains(emptyCellText) && !isFilledNumI){
            mathRight = mathRight.replaceFirst(emptyCellText, numI.toString());
            isFilledNumI = true;
          }
          if(mathRight.contains(emptyCellText) && !isFilledNumJ){
            mathRight = mathRight.replaceFirst(emptyCellText, numJ.toString());
            isFilledNumJ = true;
          }
          var isCorrect = ( mathLeft.interpret() == mathRight.interpret());
          if(isCorrect){
            var list = [numI, numJ];
            var isExistedList = false;
            for(var org in result){
              if(org.length == list.length){
                var isSamed = true;
                for(int index = 0; index < org.length; index++){
                  if(org[index] != list[index]){
                    isSamed = false;
                    break;
                  }
                }
                if(isSamed){
                  isExistedList = true;
                  break;
                }
              }
            }
            if(!isExistedList){
              result.add(list);
            }
          }
        }
      }
    } else if(emptyCells.length == 3){
      for(int i = 0; i < numberBottomList.length; i++){
        if(result.length >= 6){
          break;
        }
        for(int j = 0; j < numberBottomList.length; j++){
          var numI = numberBottomList.value[i];
          var numJ = numberBottomList.value[j];
          if(j == i || numI == none_number || numJ == none_number )continue;
          if(result.length >= 6){
            break;
          }
          for(int k = 0; k < numberBottomList.length; k++){
            var numK = numberBottomList.value[k];
            if(k == j || k == i || numK == none_number)continue;
            var isFilledNumI = false, isFilledNumJ = false, isFilledNumK = false;
            var mathLeft = orgLeft;
            var mathRight = orgRight;
            if(mathLeft.contains(emptyCellText) && !isFilledNumI){
              mathLeft = mathLeft.replaceFirst(emptyCellText, numI.toString());
              isFilledNumI = true;
            }
            if(mathLeft.contains(emptyCellText) && !isFilledNumJ){
              mathLeft = mathLeft.replaceFirst(emptyCellText, numJ.toString());
              isFilledNumJ = true;
            }
            if(mathLeft.contains(emptyCellText) && !isFilledNumK){
              mathLeft = mathLeft.replaceFirst(emptyCellText, numK.toString());
              isFilledNumK = true;
            }
            if(mathRight.contains(emptyCellText) && !isFilledNumI){
              mathRight = mathRight.replaceFirst(emptyCellText, numI.toString());
              isFilledNumI = true;
            }
            if(mathRight.contains(emptyCellText) && !isFilledNumJ){
              mathRight = mathRight.replaceFirst(emptyCellText, numJ.toString());
              isFilledNumJ = true;
            }
            if(mathRight.contains(emptyCellText) && !isFilledNumK){
              mathRight = mathRight.replaceFirst(emptyCellText, numK.toString());
              isFilledNumK = true;
            }
            var isCorrect = ( mathLeft.interpret() == mathRight.interpret());
            if(isCorrect){
              var list = [numI, numJ, numK];
              var isExistedList = false;
              for(var org in result){
                if(org.length == list.length){
                  var isSamed = true;
                  for(int index = 0; index < org.length; index++){
                    if(org[index] != list[index]){
                      isSamed = false;
                      break;
                    }
                  }
                  if(isSamed){
                    isExistedList = true;
                    break;
                  }
                }
              }
              if(!isExistedList){
                result.add(list);
              }
            }
          }
        }
      }
    }
    return result;
  }
  final RxString messeageAction = ''.obs;
  void inputNumber(int number) {
    // input to table cell map top
    if (numberIndexTopSelect.value >= 0) {
      playSoundButtonClick();
      if (number <= none_number) {
        numbersBoardInput.value = "";
        numberTopList.value[numberIndexTopSelect.value] = noneTileCellText;
        numberTopList.refresh();
      } else {
        numbersBoardInput.value = '${numbersBoardInput.value}$number'.trim();
        numberTopList.value[numberIndexTopSelect.value] =
            numbersBoardInput.value;
        numberTopList.refresh();
      }
      return;
    }
    // input bottom list number
    if (numberIndexBottomSelect.value >= 0) {
      playSoundButtonClick();
      if (number <= none_number) {
        numbersBoardInput.value = "";
        numberBottomList.value[numberIndexBottomSelect.value] = none_number;
        numberBottomList.refresh();
      } else {
        numbersBoardInput.value = '${numbersBoardInput.value}$number'.trim();
        var numberFilled = int.tryParse(numbersBoardInput.value) ?? none_number;
        numberBottomList.value[numberIndexBottomSelect.value] = numberFilled;
        numberBottomList.refresh();
        if (autoNextCellBottomNumber100.value && numberFilled >= 100 ||
            !autoNextCellBottomNumber100.value && numberFilled >= 10) {
          var prevI = numberIndexBottomSelect.value - 1;
          var nexI = numberIndexBottomSelect.value + 1;
          if (prevI >= 0 &&
              nexI < numberBottomList.value.length &&
              numberBottomList.value[prevI] != none_number &&
              numberBottomList.value[nexI] == none_number) {
            numberIndexBottomSelect.value = nexI;
            numbersBoardInput.value = "";
          } else if (prevI >= 0 &&
              nexI < numberBottomList.value.length &&
              numberBottomList.value[prevI] == none_number &&
              numberBottomList.value[nexI] != none_number) {
            numberIndexBottomSelect.value = prevI;
            numbersBoardInput.value = "";
          } else if (nexI < numberBottomList.value.length &&
              numberBottomList.value[nexI] == none_number) {
            numberIndexBottomSelect.value = nexI;
            numbersBoardInput.value = "";
          }
        }
      }
      return;
    }
  }

  final RxBool autoNextCellBottomNumber100 = false.obs;

  final RxBool isShowEmptyCell = true.obs;
  final RxBool isCongTruNhanChiaBang = true.obs;
  void CheckPhepCongTruNhanCHiaBangEmptyShowHide() {
    var prevI = numberIndexTopSelect.value - 1;
    var nextI = numberIndexTopSelect.value + 1;
    if (numberIndexTopSelect.value >= 0 &&
        numberTopList.value[numberIndexTopSelect.value] != emptyCellText) {
      if (prevI >= 0 && numberTopList.value[prevI] == emptyCellText) {
        isShowEmptyCell.value = false;
        isCongTruNhanChiaBang.value = true;
      } else if (nextI < numberTopList.value.length &&
          numberTopList.value[nextI] == emptyCellText) {
        isShowEmptyCell.value = false;
        isCongTruNhanChiaBang.value = true;
      } else if (prevI >= 0 &&
          isCongTruNhanChiaOrBAng(numberTopList.value[prevI])) {
        isShowEmptyCell.value = true;
        isCongTruNhanChiaBang.value = false;
      } else if (nextI < numberTopList.value.length &&
          isCongTruNhanChiaOrBAng(numberTopList.value[nextI])) {
        isShowEmptyCell.value = true;
        isCongTruNhanChiaBang.value = false;
      } else {
        isShowEmptyCell.value = true;
        isCongTruNhanChiaBang.value = true;
      }
    } else {
      isShowEmptyCell.value = true;
      isCongTruNhanChiaBang.value = true;
    }
  }

  bool isCongTruNhanChiaOrBAng(String pt) {
    return pt == "+" ||
        pt == '-' ||
        pt == PhepNhanText ||
        pt == PhepChiaText ||
        pt == '=';
  }

  void ParseLevelFromTextInput() {
    var data = textController.text.trim().replaceFirst('_HDV', '');
    if (!data.contains('|') || !data.contains(',') || data.length < 10) {
      showMessageToUserNow("Chuỗi điền vào không đúng!");
      return;
    }
    reset();
    listCellNumber.clear();
    numberBottomListFilled.clear();
    var split = data.split('|');
    for (int i = 0; i < split.length - 1; i++) {
      var splitI = split[i].split(',');
      var x = int.tryParse(splitI[0]) ?? 0;
      var y = int.tryParse(splitI[1]) ?? 0;
      var text = splitI[2];
      numberTopList.value[y * matrixMaxCol + x] = text;
    }
    var lastSplit = split.last.split(',');
    for (int i = 0; i < lastSplit.length; i++) {
      var number = lastSplit[i];
      numberBottomList.value[i] = int.tryParse(number) ?? none_number;
    }
    numberTopList.refresh();
    numberBottomList.refresh();
  }
  bool IsWrongMeRoi(int number, int id, List<CellNumber> quests, List<int> numberBottomList) {
    var orgLeft = MathExpress(quests, isMathLeftBang: true);
    var orgRight = MathExpress(quests, isMathLeftBang: false);
    var indexNumber = numberBottomList.firstWhere((element) => element == number);
    var emptyCells = emptyCellList(quests);
    if(emptyCells.length == 2){
      for(int i = 0; i < numberBottomList.length; i++){
        if(i != indexNumber){
          bool isReplaceNum = false, isReplaceNumI = false;
          var leftMat1 = orgLeft;
          var rightMath1 = orgRight;
          var numI = numberBottomList[i];
          if(orgLeft.contains(emptyCellText) && !isReplaceNum){
            leftMat1 = leftMat1.replaceFirst(emptyCellText, number.toString());
            isReplaceNum = true;
          }
          if(orgLeft.contains(emptyCellText) && !isReplaceNumI){
            leftMat1 = leftMat1.replaceFirst(emptyCellText, numI.toString());
            isReplaceNumI = true;
          }
          if(orgRight.contains(emptyCellText) && !isReplaceNum){
            rightMath1 = rightMath1.replaceFirst(emptyCellText, number.toString());
            isReplaceNum = true;
          }
          if(orgRight.contains(emptyCellText) && !isReplaceNumI){
            rightMath1 = rightMath1.replaceFirst(emptyCellText, numI.toString());
            isReplaceNumI = true;
          }
          if(leftMat1.interpret() == rightMath1.interpret()){
            return false;
          }
          //
          isReplaceNumI = false;
          isReplaceNum = false;
          if(orgLeft.contains(emptyCellText) && !isReplaceNumI){
            leftMat1 = leftMat1.replaceFirst(emptyCellText, numI.toString());
            isReplaceNumI = true;
          }
          if(orgLeft.contains(emptyCellText) && !isReplaceNum){
            leftMat1 = leftMat1.replaceFirst(emptyCellText, number.toString());
            isReplaceNum = true;
          }
          if(orgRight.contains(emptyCellText) && !isReplaceNumI){
            rightMath1 = rightMath1.replaceFirst(emptyCellText, numI.toString());
            isReplaceNumI = true;
          }
          if(orgRight.contains(emptyCellText) && !isReplaceNum){
            rightMath1 = rightMath1.replaceFirst(emptyCellText, number.toString());
            isReplaceNum = true;
          }
          if(leftMat1.interpret() == rightMath1.interpret()){
            return false;
          }
        }
      }
    } else  if(emptyCells.length == 3){
      for(int j = 0; j < numberBottomList.length; j++){
        if(j == indexNumber){
          continue;
        }
        for(int k = 0; j < numberBottomList.length; k++){
          if(k == j || k == indexNumber){
            continue;
          }
          var numJ = numberBottomList[j];
          var numK = numberBottomList[k];
          bool isReplaceNumI = false, isReplaceNumJ = false, isReplaceNumK = false;
          var leftMat = orgLeft;
          var rightMath = orgRight;
          if(leftMat.contains(emptyCellText) && !isReplaceNumI){
            leftMat =
                leftMat.replaceFirst(emptyCellText, number.toString());
            isReplaceNumI = true;
          }
          if(leftMat.contains(emptyCellText) && !isReplaceNumJ){
            leftMat =
                leftMat.replaceFirst(emptyCellText, numJ.toString());
            isReplaceNumJ = true;
          }
          if(leftMat.contains(emptyCellText) && !isReplaceNumK){
            leftMat =
                leftMat.replaceFirst(emptyCellText, numK.toString());
            isReplaceNumK = true;
          }
          if(rightMath.contains(emptyCellText) && !isReplaceNumI){
            rightMath =
                rightMath.replaceFirst(emptyCellText, number.toString());
            isReplaceNumI = true;
          }
          if(rightMath.contains(emptyCellText) && !isReplaceNumJ){
            rightMath =
                rightMath.replaceFirst(emptyCellText, numJ.toString());
            isReplaceNumJ = true;
          }
          if(rightMath.contains(emptyCellText) && !isReplaceNumK){
            rightMath =
                rightMath.replaceFirst(emptyCellText, numK.toString());
            isReplaceNumK = true;
          }
          var isCorrectAnswer = (leftMat.interpret() == rightMath.interpret());
          if(isCorrectAnswer){
            return false;
          }
        }
      }
    }
    return true;
  }
}


