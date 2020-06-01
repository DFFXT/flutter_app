import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:exp/base/LifeCycleOwner.dart';
import 'package:exp/module/draw/panelPlug.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class DrawPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("draw panel"),
        leading: Text("leading"),
        flexibleSpace: Text("flex"),
        actions: <Widget>[
          Container(
            width: 60,
            height: 30,
            child: FlatButton(
              onPressed: (){
                showModalBottomSheet(
                  enableDrag: false,
                  useRootNavigator: true,
                  isScrollControlled: true,
                    context: context,
                    builder: (ctx) {
                      return DraggableScrollableSheet(
                        expand: false,
                        minChildSize: 0.5,
                        builder: (ctx,controller) {
                          return ListView.builder(
                            controller: controller,
                              itemBuilder: (ctx,index){
                            return Text("$index");
                          });
                        },
                      );
                    }
                  );
              },
              child: Text("ss"),
            ),
          )

        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        //使用Provider必须在widget的ancestor节点处使用
        child: ChangeNotifierProvider<Day>(
          create: (_)=>Day(),
          child: TestProvider(),
        ),
      ),
    );
  }
}

class _Panel extends StatefulWidget {
  @override
  State createState() {
    return _PanelState();
  }
}

class _PanelState extends LifeCycleOwnerState {
  var list = List<Operation>();
  Lines _lastedLines;
  var _pointerSize =0;
  var panelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print("rebuild");
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: Listener(
                key: panelKey,
                onPointerUp: (e){
                  _pointerSize--;
                  if(_pointerSize==0&&_lastedLines!=null){
                    _lastedLines.tryImmutable(panelKey.currentContext.size);
                    _lastedLines = null;
                  }
                },
                onPointerMove: (e) {
                  setState(() {
                    if(_lastedLines!=null&&(list.length==0||list[list.length-1]!=_lastedLines)){
                      list.add(_lastedLines);
                    }
                    _lastedLines.addOffset(e.localPosition);
                  });
                },
                onPointerDown: (e) {
                  _pointerSize++;
                  if(_lastedLines==null){
                    _lastedLines = Lines();
                  }
                },
                child: CustomPaint(
                  isComplex: true,
                  painter: Painter(list),
                )),
          ),
        ),
        Row(
          children: <Widget>[
            Text("${Provider.of<Day>(context).a}"),
            GestureDetector(
              onTap: (){
                Provider.of<Day>(context,listen: false).add(123);
                /*setState(() {
                  list.clear();
                });*/
              },
              child: TestProvider(),
            )
          ],
        )
      ],
    );
  }
}

class Painter extends CustomPainter {
  ui.Image image;

  Painter(List<Operation> list) {
    this.data = list;
    ui.PictureRecorder p = ui.PictureRecorder();
    Canvas canvas = Canvas(p);
    canvas.drawColor(Colors.blue, BlendMode.xor);
    p.endRecording().toImage(300, 300).then((value) {
      image = value;
    });
  }

  Paint _paint = Paint();
  var data = List<Operation>();

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = Colors.deepOrange;
    for (int i = 0; i < data.length; i++) {
      data[i].draw(canvas,size);
    }
    //Oval().draw(canvas,size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class TestProvider extends StatefulWidget{

  @override
  State createState() {
    return _T();
  }
}
class _T extends State{

  @override
  Widget build(BuildContext context) {
    return Text("${Provider.of<Day>(context).a}");
  }
}
