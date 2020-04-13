import 'package:exp/base/LifeCycleOwner.dart';
import 'package:exp/base/TopBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
                child: GameWidget(),
              );
            }),
      ),
    );
  }
}

class GameWidget extends StatefulWidget {
  @override
  State createState() => GameSate();
}

double cellWidth = 0;
double cellHeight = 0;
const int EMPTY = 0;
const int SELF = 1;

class GameSate extends State with SingleTickerProviderStateMixin{
  List<Widget> cells = List();
  List<int> a = List();
  double left=0;
  AnimationController control;
  Animation<double> animator;
  GameSate() {
    a.addAll([SELF, 0, 0, 0, 0, 0, 0,0, 0]);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    control = AnimationController (duration: Duration(seconds: 3),vsync: this);
    animator =new Tween<double>(begin: 0, end: 80).animate(control);
    control.addListener((){
      setState(() {
        var value = animator.value;
        print(value);
        if(value == cellWidth){
          //left = 0.toDouble();
        }else{
          left = value.toDouble();
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    cellWidth = MediaQuery.of(context).size.width / 3;
    cellHeight = cellWidth;

    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: a.length,
      itemBuilder: (ctx, index) {
        var _type = a[index];
        /*if(index == 8){
          return Test(10,Text("ssss"));
        }*/
  
        return
          PhysicalShape(
            color: Colors.transparent,
            clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder()
            ),
            elevation: 2,
            child: Container(
              color: Colors.red,
              margin: EdgeInsets.all(10),
              child: Text("xxxxf"),
            ),
          );
      /*UnconstrainedBox(
          constrainedAxis: Axis.vertical,
         child: Container(
           color: Colors.brown,
           margin: EdgeInsets.only(top: index == 0? left : 0),
           child: Material(
             elevation: 19-index.toDouble(),
             color: Colors.red,
             child:GestureDetector(
               onTapUp: (e) {
                 print("object");
                 var selfIndex = a.indexOf(SELF);
                 if ((selfIndex + 1) % a.length == index ||
                     (selfIndex - 1) % a.length == index ||
                     (selfIndex + 3) % a.length == index ||
                     (selfIndex - 3) % a.length == index) {
                a[index] = SELF;
                   control.forward(from: 0);
                 }
               },
               child: Visibility(
                 maintainState: true,
                 maintainAnimation: true,
                 maintainSize: true,
                 child: Text("xxx",style: TextStyle(fontSize: 90),),
               ),
             ) ,
           ),
         ),
        );*/


      },
    );
  }
}

class W extends CustomSingleChildLayout{



  @override
  RenderCustomSingleChildLayoutBox createRenderObject(BuildContext context) {

    return RB(4);
  }
}

class Test extends SingleChildRenderObjectWidget{

  const Test(this.elevation,Widget w):super(child:w);
  final double elevation;
  @override
  RenderCustomSingleChildLayoutBox createRenderObject(BuildContext context) {
    return RB(elevation);
  }

  @override
  SingleChildRenderObjectElement createElement() {
    return SingleChildRenderObjectElement(this);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('elevation', elevation));
  }
}

class RB extends RenderCustomSingleChildLayoutBox{
  double elevation;
  RB(this.elevation):super(delegate:Delegate());

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    config.elevation = 20;
    super.describeSemanticsConfiguration(config);
  }

}

class Delegate extends SingleChildLayoutDelegate{

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return false;
  }
}

