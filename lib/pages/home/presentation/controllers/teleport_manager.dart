
class TeleportManager {
  var listTeleportBlocksCouple = <String>[];
  var listTeleportBlocksCoupleShort = <String>[];
  String? _teleportStart,  _teleportEnd;
  TeleportManager();

  void init(){
    clear();
  }
  void setListTeleportBlocksCoupleByImportFileData(List<String> data){
    if(data.isNotEmpty){
      listTeleportBlocksCouple = data;
    }
  }
  void clear(){
    _teleportStart = null;
    _teleportEnd = null;
    listTeleportBlocksCouple.clear();
    listTeleportBlocksCoupleShort.clear();
  }
  void addIndexIJTeleport({required int iRow, required int jCol}){
    var idIRowJCol = _idFromIRowJCol(iRow: iRow, jCol: jCol);
    var exists = listTeleportBlocksCouple.where((element) => element.contains(idIRowJCol));
    if(exists.isEmpty){
      if(_teleportStart == null){
        _teleportStart = idIRowJCol;
      } else {
        if(idIRowJCol != _teleportStart){
          _teleportEnd = idIRowJCol;
          listTeleportBlocksCouple.add('$_teleportStart|$_teleportEnd');
          _teleportStart = null;
          _teleportEnd = null;
        }
      }
    }
  }

  List<int>? removeIndexJITeleport({required int iRow, required int jCol}){
    List<int>? result;
    var idIRowJCol = _idFromIRowJCol(iRow: iRow, jCol: jCol);
    if(idIRowJCol == _teleportStart){
      if(_teleportEnd != null){
        result = _iRowJColTeleportEnd();
      }
      listTeleportBlocksCouple.removeWhere((element) => element.startsWith(_teleportStart!));
      _teleportStart = null;
    } else if(idIRowJCol == _teleportEnd){
      if(_teleportStart != null){
        result = _iRowJColTeleportStart();
      }
      listTeleportBlocksCouple.removeWhere((element) => element.endsWith(_teleportEnd!));
      _teleportEnd = null;
    } else {
      String? needRemove;
      for(var idIJ in listTeleportBlocksCouple){
        if(idIJ.startsWith(idIRowJCol)){
          needRemove = idIJ;
          result = _iRowJColTeleportById(idIJ.split('|')[1]);
          break;
        } else if(idIJ.endsWith(idIRowJCol)){
          needRemove = idIJ;
          result = _iRowJColTeleportById(idIJ.split('|')[0]);
          break;
        }
      }
      if(needRemove != null){
        listTeleportBlocksCouple.removeWhere((element) => element == needRemove);
      }
    }
    return result;
  }
  bool isTeleportCoupleIsSatisfy(){
    return _teleportStart == null && _teleportEnd == null;
  }
  String _idFromIRowJCol({required int iRow, required int jCol}){
    return '$iRow,$jCol';
  }
  List<int> _iRowJColTeleportById(String? id){
    if(id == null) {
      return [];
    }
    var arr = id!.split(',');
    return [int.parse(arr[0]), int.parse(arr[1])];
  }
  List<int> _iRowJColTeleportStart(){
    return _iRowJColTeleportById(_teleportStart);
  }
  List<int> _iRowJColTeleportEnd(){
    return _iRowJColTeleportById(_teleportEnd);
  }
  void updateListTeleportBlocksCoupleShort({required int deltaRow, required int deltaCol}){
    if (deltaRow < 0 || deltaCol < 0 || listTeleportBlocksCouple.isEmpty) {
      return;
    }
    listTeleportBlocksCoupleShort.clear();
    for(var list in listTeleportBlocksCouple){
      var arr = list.split('|');
      if(arr.length == 2){
        var start = _iRowJColTeleportById(arr[0]);
        var end = _iRowJColTeleportById(arr[1]);
        var newIRowStart = start[0] - deltaRow;
        var newIColStart = start[1] - deltaCol;
        var newStart = _idFromIRowJCol(iRow: newIRowStart, jCol: newIColStart);
        var newIRowEnd = end[0] - deltaRow;
        var newIColEnd = end[1] - deltaCol;
        var newEnd = _idFromIRowJCol(iRow: newIRowEnd, jCol: newIColEnd);
        listTeleportBlocksCoupleShort.add('$newStart|$newEnd');
      }
    }
  }
  List<int> findCoupleOfTeleport({required int iRow, required int jCol,  bool getFromShortList = true}){
    var list = listTeleportBlocksCoupleShort;
    if(!getFromShortList){
      list = listTeleportBlocksCouple;
    }
    var result = <int>[];
    var idIRowJCol = _idFromIRowJCol(iRow: iRow, jCol: jCol);
    for(var idIJ in list){
      if(idIJ.startsWith(idIRowJCol)){
        result = _iRowJColTeleportById(idIJ.split('|')[1]);
      } else if(idIJ.endsWith(idIRowJCol)){
        result = _iRowJColTeleportById(idIJ.split('|')[0]);
        break;
      }
    }
    print('findCoupleOfTeleport: $idIRowJCol | $result | $list');
    return result;
  }
  String findIdCoupleOfTeleport({required int iRow, required int jCol,  bool getFromShortList = true}){
    var list = listTeleportBlocksCoupleShort;
    if(!getFromShortList){
      list = listTeleportBlocksCouple;
    }
    var idIRowJCol = _idFromIRowJCol(iRow: iRow, jCol: jCol);
    for(int i = 0; i < list.length; i++){
      var idIJ = list[i];
      if(idIJ.startsWith(idIRowJCol) || idIJ.endsWith(idIRowJCol)){
        return (i+1).toString();
      }
    }
    return '';
  }
}