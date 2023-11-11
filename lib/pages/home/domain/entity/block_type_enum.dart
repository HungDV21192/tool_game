enum BlockType {
  //0------1------2-----3--------4---------5-----------6---------7-----------8-------------9-------------10--------------11-----------12----13---14---
  start, normal, one, magnet, pushTop, pushRight, pushBottom, pushLeft, edgeTopLeft, edgeTopRight, edgeBottomLeft, edgeBottomRight, telepot,bomb,tank
}

extension BlockTypeExtension on BlockType {

  String get name {
    switch (this) {
      case BlockType.normal:
        return toString();
      default:
        return toString();
    }
  }
  String get intro {
    switch(this){
      case BlockType.start:
        return 'Điểm bắt đầu, Level bắt buộc có 1 và chỉ 1 điểm bắt đầu!';
      case BlockType.normal:
        return 'Block mặc định';
      case BlockType.one:
        return 'Block locate, Ball chỉ được phép đi qua 1 lần';
      case BlockType.magnet:
        return 'Block nam châm, ball đi qua thì dừng lại';
      case BlockType.pushTop:
        return 'Block push top, ball đi qua thì bị đẩy move up';
      case BlockType.pushBottom:
        return 'Block push bottom, ball đi qua thì bị đẩy move down';
      case BlockType.pushLeft:
        return 'Block push left, ball đi qua thì bị đẩy move left';
      case BlockType.pushRight:
        return 'Block push right, ball đi qua thì bị đẩy move right';
      case BlockType.edgeTopLeft:
        return 'Ball move up/ move left -> trượt sang block bên cạnh theo chiều edge';
      case BlockType.edgeTopRight:
        return 'Ball move up/ move right -> trượt sang block bên cạnh theo chiều edge';
      case BlockType.edgeBottomLeft:
        return 'Ball move down/ move left -> trượt sang block bên cạnh theo chiều edge';
      case BlockType.edgeBottomRight:
        return 'Ball move down/ move right -> trượt sang block bên cạnh theo chiều edge';
      case BlockType.telepot:
        return 'Teleport, 1 level chỉ có 0 hoặc theo cặp (số block telepot chẵn)';
      case BlockType.tank:
        return 'Block tank, có đạn bắn ra định kì, đạn đâm vào sẽ chết bóng!';
      case BlockType.bomb:
        return 'Block bomb, Ball đi vào là Game Over!!';
    }
  }
  bool get isNoNeedPassIt{
    switch (this) {
      case BlockType.start:
        return true;
      case BlockType.telepot:
        return true;
      case BlockType.bomb:
        return true;
      default:
        return false;
    }
  }
  bool get isCanDrawAreaMultiCell{
    switch (this) {
      case BlockType.normal:
        return true;
      case BlockType.one:
        return true;
      default:
        return false;
    }
  }
}