import 'package:flutter/material.dart';

///AppBar
class TopBar extends StatelessWidget implements PreferredSizeWidget{

  @override
  Size get preferredSize {
    return Size.fromHeight(56);
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Container(
      height: MediaQuery.of(context).size.height,

      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black12,offset: Offset(0,-2),spreadRadius: 0,blurRadius: 0),
            BoxShadow(color: Colors.black12,offset: Offset(0,2),spreadRadius: 0,blurRadius: 0),
          ]
      ),
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        color: Colors.deepOrange,
        child: Text("xxx"),
      ),
    );
  }


}