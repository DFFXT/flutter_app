import 'package:flutter/material.dart';

///AppBar
class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize {
    return Size.fromHeight(40);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueAccent,
      elevation: 3,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top, 0, 0),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              child: Image.asset("assets/icon_bd.png"),
            )
            ,
            Expanded(
              child: Container(
                alignment: Alignment(0,0),
                child: Text("title",maxLines: 1,softWrap: false,overflow: TextOverflow.ellipsis,),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              child: Image.asset("assets/icon_kg.png"),
            )
          ],
        ),
      ),
    );
  }
}
