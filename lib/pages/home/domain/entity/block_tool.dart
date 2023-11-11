import 'dart:convert';
import 'package:tool_eat_all_game/pages/home/domain/entity/block_type_enum.dart';

class BlockTool {
  bool isChoose;
  bool isAvailable;
  final BlockType blockType;

  BlockTool({required this.blockType, this.isChoose = false, this.isAvailable = true});

  factory BlockTool.fromRawJson(String str) =>
      BlockTool.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory BlockTool.fromJson(Map<String, dynamic> json) => BlockTool(
    isChoose: json["isChoose"] as bool,
    blockType: json["blockType"] as BlockType,
    isAvailable: json["isAvailable"] as bool,
  );

  Map<String, dynamic> toJson() => {
    "isChoose": isChoose,
    "blockType": blockType,
    "isAvailable": isAvailable,
  };

}