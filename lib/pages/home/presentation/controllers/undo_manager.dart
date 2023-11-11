
import 'dart:convert';

import 'package:tool_eat_all_game/pages/home/domain/entity/step_undo.dart';

class UndoManager {
  List<StepUndo> undoList = [];
  List<StepUndo> reUndoList = [];

  UndoManager();

  void init() {
  }

  void addMultiToUndoList({List<List<int>>? blockIjArrs}){
    var step = StepUndo();
    step.addValue(blockIjArrs:blockIjArrs);
    undoList.add(step);
    //print('addMultiToUndoList: ${jsonEncode(undoList)}');c
  }

  void addToUndoList({List<int>? blockIjArr}){
    var step = StepUndo();
    step.setValue(blockIjArr: blockIjArr);
    undoList.add(step);
    //print('addToUndoList: ${jsonEncode(undoList)}');c
  }

  void reset(){
    undoList.clear();
    reUndoList.clear();
  }
  StepUndo? undoStep(){
    if(undoList.isEmpty){
      return null;
    }
    var last = undoList.last;
    reUndoList.add(last);
    undoList.removeLast();
    return last;
  }

  StepUndo? reUndoStep(){
    if(reUndoList.isEmpty){
      return null;
    }
    var last = reUndoList.last;
    reUndoList.removeLast();
    return last;
  }
}