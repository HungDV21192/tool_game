import 'package:flutter/material.dart';
import 'package:tool_eat_all_game/utils/constants.dart';

enum NumberType { None, Empty, Number, Cong, Tru, Nhan, Chia, Bang }

class NumberMapButton extends StatelessWidget {
  final String text;
  final NumberType type;
  final double width;
  final bool isSelected;
  final int? numberFilled;
  const NumberMapButton(
      {Key? key,
      this.text = "",
      this.type = NumberType.None,
      this.width = sizeBlock,
      this.numberFilled,
      this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorBKG = Colors.white;
    var colorBorder = Colors.black26;
    var textDisplay = text;
    var textColor = Colors.black;
    if (type == NumberType.None) {
      colorBKG = Colors.white;
      colorBorder = Colors.black12;
      textDisplay = "";
    } else if (type == NumberType.Empty) {
      colorBKG = const Color(0xFFfff9e3);
      colorBorder = Colors.black26;
      textDisplay = "";
    } else {
      colorBKG = const Color(0xFFfeefb8);
      colorBorder = Colors.black54;
      textDisplay = text;
    }
    if(type == NumberType.Empty && numberFilled != null){
      colorBKG = const Color(0xFFe3f9f7);
      textDisplay = '$numberFilled';
      textColor = const Color(0xFF088d34);
    }
    if (isSelected) {
      colorBKG = Colors.redAccent.withOpacity(0.3);
    }
    var sizeText = type == NumberType.Number ? width * 0.5 : width * 0.6;
    if (textDisplay.length >= 3) {
      sizeText = sizeText * 0.75;
    }
    return Container(
        width: width,
        height: width,
        alignment: Alignment.center,
        child: Text(
          textDisplay,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textColor,
              fontSize: sizeText,
              fontWeight: FontWeight.w500),
        ),
        decoration: BoxDecoration(
          color: colorBKG,
          border: Border.all(width: 1, color: colorBorder),
        ));
  }
}
