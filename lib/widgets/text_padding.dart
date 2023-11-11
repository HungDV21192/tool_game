import 'package:flutter/material.dart';

class TextPadding extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final EdgeInsets padding;
  final TextAlign textAlign;
  final int maxLines;
  const TextPadding(
      this.title,{
        Key? key,
        this.textAlign = TextAlign.start,
        this.style,
        this.maxLines = 10,
        this.padding = EdgeInsets.zero,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: Text(title, maxLines: maxLines, overflow: TextOverflow.ellipsis, textAlign: textAlign, style: style,),);
  }
}