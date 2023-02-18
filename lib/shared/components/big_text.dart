// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overFlow;
  BigText({Key? key, this.color = const Color(0xFF332d2d), required this.text, this.size = 0.0, this.overFlow = TextOverflow.ellipsis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overFlow,
      style: TextStyle(
        fontSize: size ==0? 20 : size,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
        color: color,
      ),
    );
  }
}
