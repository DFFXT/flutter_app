
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

class TestPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.all(40),
      child: Text("sfdsfsdf",
          style: TextStyle(backgroundColor: Colors.amber,
          decoration: TextDecoration.lineThrough,
            decorationStyle: TextDecorationStyle.dashed
      )
      ),
    );
  }
}