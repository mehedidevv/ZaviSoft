import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    this.maxLines,
    this.textAlign = TextAlign.center,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.color = Colors.black,
    required this.text,
    this.overflow = TextOverflow.fade,
    this.letterSpace,
    this.underline = false,
    this.italic = false,
    this.fontFamily = 'NeueMontreal',
  });

  final double left;
  final double right;
  final double top;
  final double bottom;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final double? letterSpace;
  final bool underline;
  final bool italic;
  final String fontFamily;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          color: color,
          letterSpacing: letterSpace,
          decoration:
          underline ? TextDecoration.underline : TextDecoration.none,
          decorationColor: const Color(0XFFA11C11),
        ),
      ),
    );
  }
}