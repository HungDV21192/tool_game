import 'package:flutter/material.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/block.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/block_type_enum.dart';
import 'package:tool_eat_all_game/utils/constants.dart';
import 'package:tool_eat_all_game/widgets/block_type_widget.dart';

class BlockCell extends StatelessWidget{
  final VoidCallback? onPressed;
  final Block block;
  final double size;
  final String? idCoupleTelepot;
  const BlockCell({Key? key,
    required this.block,
    this.onPressed,
    this.size = sizeBlock,
    this.idCoupleTelepot,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return onPressed == null ? child() : InkWell(
      onTap: onPressed,
      child: child(),
    );
  }
  Widget child(){
    return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: BlockTypeWidget(blockType: block.blockType,
            size: size,
            isDrew: block.isDrew,
            idCoupleTelepot: idCoupleTelepot,
            isDisableBlock: block.blockType == BlockType.one && block.isDrew)
    );
  }
}