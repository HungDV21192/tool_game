import 'package:flutter/material.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/block.dart';
import 'package:tool_eat_all_game/utils/constants.dart';
import 'package:tool_eat_all_game/widgets/block_type_widget.dart';

class TileMapCell extends StatelessWidget{
  final VoidCallback? onPressed;
  final Block? block;
  final double size;
  final Color? colorFocusBorder;
  final String? idCoupleTelepot;
  const TileMapCell({Key? key,
    this.onPressed,
    required this.block,
    this.size = sizeBlock,
    this.colorFocusBorder,
    this.idCoupleTelepot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: colorFocusBorder == null ? child() : Stack(
        children: [
          child(),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: colorFocusBorder!
              ),
              color: colorFocusBorder!.withOpacity(0.25),
            ),
          ),
        ],
      ),
    );
  }
  Widget child(){
    if(block == null){
      return Container(
        width: size,
        height: size,
        decoration: _decoration(),
      );
    }
    return BlockTypeWidget(blockType: block!.blockType, size: size, idCoupleTelepot: idCoupleTelepot,);
  }
  BoxDecoration _decoration() {
    return BoxDecoration(
      border: Border.all(
          width:  0.5,
          color: Colors.black26
      ),
      color: Colors.white,
    );
  }
}