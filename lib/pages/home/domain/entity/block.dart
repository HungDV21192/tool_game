import 'dart:convert';
import 'package:tool_eat_all_game/pages/home/domain/entity/block_type_enum.dart';

class Block {
  bool isDrew;
  final BlockType blockType;

  Block({required this.blockType, this.isDrew = false});

  factory Block.fromRawJson(String str) =>
      Block.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory Block.fromJson(Map<String, dynamic> json) => Block(
    isDrew: json["isDrew"] as bool,
    blockType: json["blockType"] as BlockType,
  );

  Map<String, dynamic> toJson() => {
    "isDrew": isDrew,
    "blockType": blockType,
  };

  Block clone(){
    return Block(blockType: blockType, isDrew: false);
  }
}