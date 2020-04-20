import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LandingPageState();
  }
}

class _LandingPageState extends State {
  List<String> list = List<String>();

  _LandingPageState(){
    list.add("value");
    list.add("value");
    list.add("value");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[
              Text("ac"),
              Text("ac")
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text("title"),
              background: Container(
                margin: EdgeInsets.only(bottom: 72),
                 child:Image.asset("assets/icon_bd.png",fit:BoxFit.fitHeight ,)
              ),
            ),
            leading: Text("leading"),
            pinned: true,
            floating: true,
            bottom: Bottom(),
            expandedHeight: 270,
            primary: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((ctx,index){
              return GestureDetector(
                onTap: (){

                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 0.1
                      )
                    )
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text("${index+1}. "+list[index]),
                ),
              );
            },
            childCount: list.length),
          )
        ],
      ),
    );
  }
}

class Bottom extends StatelessWidget implements PreferredSizeWidget{

  @override
  Widget build(BuildContext context) {
    var paint = Paint();
    paint.color = Colors.red;
    paint.blendMode = BlendMode.srcIn;

    return Column(
      children: <Widget>[
        Container(
          color: Colors.blueAccent,
        ),
        Container(
          width: double.infinity,
          height: 64,
          color: Colors.cyanAccent,
          child: LayoutBuilder(
            builder: (ctx,cons){
              print(cons);
              return Text("ssssssssssss",style: TextStyle(fontSize: 30,background: paint),);
            },
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(64);
  }

}
