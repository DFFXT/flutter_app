import 'package:exp/base/TopBar.dart';
import 'package:exp/module/draw/panelPlug.dart';
import 'package:exp/module/music/bean/Music.dart';
import 'package:exp/module/music/ui/MusicItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MusicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: MultiProvider(
        providers: [ChangeNotifierProvider.value(value: Day())],
        child: _MusicWidget(),
      ),
    );
  }
}

class _MusicWidget extends StatefulWidget {
  @override
  State createState() {
    return _MusicState();
  }
}

class _MusicState extends State<_MusicWidget> {
  List<Music> musicList = List();

  @override
  void initState() {
    super.initState();
    musicList.add(Music("title"));
    musicList.add(Music("title"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.blue,
      child: ConstraintLayout(
        children: <Child>[
          Child(
            id: "B",
            widget: ConstraintLayout(
              children: [
                Child(
                  id: "C",
                  widget: Text("CCCCC"),
                ),
                Child(
                  id: "D",
                  widget: Text("DDDDDDDD"),
                )
              ],
            ),
          ),Child(
            id: "A",
            widget: Text("AAAAAAAAAAAAAAAAAAAA"),
          )
        ],
      ),
    );
  }
}
