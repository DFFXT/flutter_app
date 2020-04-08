
import 'package:exp/base/LifeCycleOwner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  @override
  State createState() {
    return _Page2State();
  }
}

class _Page2State extends LifeCycleOwnerState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: Container(
        child: PageView.builder(
            itemCount: 4,
            itemBuilder: (ctx, index) {
              return Container(
                child: Text("$index"),
              );
            }),
      ),
    );
  }
}

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
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.deepOrange,offset: Offset(1,1),spreadRadius: 0,blurRadius: 0),
        ]
      ),
      child: Text("title"),
    );
  }


}
