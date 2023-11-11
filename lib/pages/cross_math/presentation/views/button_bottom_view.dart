import 'package:flutter/material.dart';
const int none_number = -1000;
class NumberButton extends StatelessWidget {
  final int number;
  final double width;
  final bool isSelected;
  const NumberButton({
    Key? key,
    this.number = none_number,
    this.width = 40,
    this.isSelected = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isNoneNumber = (number <= none_number);
    return Container(
        width: width,
        height: width,
        margin: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Text(
          isNoneNumber ? '' : number.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: isSelected ? Colors.white :  const Color(0xFF459444).withOpacity(isNoneNumber ? 0.5 : 1),
              fontSize: width * 0.55,
              fontWeight: FontWeight.w600),
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.redAccent : const Color(0xFFe0f6f4),
          border: Border.all(width: 1, color: isNoneNumber ? Colors.black26 : Colors.black87),
        ));
  }
}
