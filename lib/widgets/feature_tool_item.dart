import 'package:flutter/material.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/feature_tool.dart';

class FeatureToolItem extends StatelessWidget{
  final VoidCallback? onPressed;
  final FeatureTool feature;
  final bool isSelect;
  final double size;
  const FeatureToolItem({Key? key,
    required this.feature,
    this.onPressed,
    this.isSelect = false,
    this.size = 40,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 2.5 * size,
        height: size,
        alignment: Alignment.center,
        child: Text(feature == FeatureTool.clearAll ? feature.nameDisplay.toUpperCase() : feature.nameDisplay, style: textStyle(),),
        decoration: isSelect ? _decorationTrue() : _decorationFalse(),
      ),
    );
  }
  TextStyle textStyle(){
    if(feature == FeatureTool.clearAll){
      return const TextStyle(color: Colors.red, fontSize: 16,
          fontWeight: FontWeight.bold);
    }
    return TextStyle(color: isSelect ? Colors.white : Colors.black87, fontSize: 16,
        fontWeight: isSelect ? FontWeight.bold : FontWeight.w500);
  }
  BoxDecoration _decorationTrue() {
    return BoxDecoration(
      border: Border.all(
          width: 1.0,
          color: Colors.green
      ),
      color: Colors.green,
      borderRadius: const BorderRadius.all(
          Radius.circular(4.0)
      ),
    );
  }
  BoxDecoration _decorationFalse() {
    return BoxDecoration(
      border: Border.all(
          width: 1.0,
          color: Colors.black54
      ),
      color: Colors.white,
      borderRadius: const BorderRadius.all(
          Radius.circular(4.0)
      ),
    );
  }
}