
import 'dart:convert';

import 'package:tool_eat_all_game/pages/cross_math/presentation/views/map_number_view.dart';
import 'package:tool_eat_all_game/utils/constants.dart';

class CellNumber {
  int x;
  int y;
  NumberType numberType;
  String text;

  CellNumber({required this.x, this.y = 0, this.numberType = NumberType.None, this.text = noneTileCellText});

  factory CellNumber.fromRawJson(String str) =>
      CellNumber.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory CellNumber.fromJson(Map<String, dynamic> json) => CellNumber(
    x: json["x"] as int,
    y: json["y"] as int,
    numberType: json["numberType"] as NumberType,
    text: json["text"] as String,
  );

  Map<String, dynamic> toJson() => {
    "x": x,
    "y": y,
    "numberType": numberType.name,
    "text": text,
  };

  int get idInTileMap => y * matrixMaxCol + x;
}