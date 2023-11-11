import 'package:flutter/material.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/block_tool.dart';
import 'package:tool_eat_all_game/utils/constants.dart';
import 'package:tool_eat_all_game/widgets/block_type_widget.dart';

class BlockToolItem extends StatelessWidget{
  final VoidCallback? onPressed;
  final BlockTool blockTool;
  const BlockToolItem({Key? key,
    required this.blockTool,
    this.onPressed
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
      return InkWell(
        onTap: blockTool.isAvailable ? onPressed : null,
        child: Opacity(
          opacity: blockTool.isAvailable ? 1 : 0.4,
          child: Stack(
            alignment: Alignment.center,
            children: [
              BlockTypeWidget(blockType: blockTool.blockType, size: sizeBlockTool,),
              !blockTool.isChoose ? const SizedBox() : Container(
                width: sizeBlockTool,
                height: sizeBlockTool,
                color: Colors.green.withOpacity(0.4),
              )
            ],
          ),
        ),
      );
  }
}