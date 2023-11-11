import 'package:flutter/material.dart';
import 'package:tool_eat_all_game/utils/constants.dart';

class Ball extends StatelessWidget{
  final VoidCallback? onPressed;
  final double size;
  const Ball({Key? key,
    this.onPressed,
    this.size = sizeBlock,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Image.asset('assets/ball.png', width: size, height: size,),
    );
  }
}