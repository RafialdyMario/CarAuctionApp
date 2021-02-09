import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class BoxColor extends StatelessWidget {
  final String color;

  BoxColor({
    Key key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      height: 25.0,
      width: 25.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        shape: BoxShape.rectangle,
        color: HexColor('#${color.toUpperCase()}'),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(1.0, 1.0),
            blurRadius: 1.0,
          )
        ],
      ),
    );
  }
}
