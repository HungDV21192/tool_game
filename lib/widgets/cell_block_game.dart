import 'package:flutter/material.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/block.dart';
import 'package:tool_eat_all_game/utils/constants.dart';
import 'package:tool_eat_all_game/widgets/ball_widget.dart';
import 'package:tool_eat_all_game/widgets/block_widget.dart';

class CellGame extends StatelessWidget{
  final VoidCallback? onPressed;
  final Block? block;
  final double size;
  final bool isBallInHere;
  final String? idCoupleTelepot;
  const CellGame({Key? key,
    required this.block,
    this.size = sizeBlock,
    this.isBallInHere = false,
    required this.idCoupleTelepot,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child();
  }
  Widget child(){
    if(block == null || block!.blockType.index < 0){
      return Container(
        width: size,
        height: size,
        decoration: _decoration(),
      );
    }
    if(isBallInHere){
      return Stack(
        alignment: Alignment.center,
        children: [
          BlockCell(block: block!, onPressed: onPressed, size: size, idCoupleTelepot: idCoupleTelepot),
          Ball(size: size * 0.9),
        ],
      );
    } else {
      return BlockCell(block: block!, onPressed: onPressed, size: size, idCoupleTelepot: idCoupleTelepot,);
    }
  }
  BoxDecoration _decoration() {
    return BoxDecoration(
      border: Border.all(
          width: 0.5,
          color: Colors.black26
      ),
      color: Colors.white,
    );
  }
}