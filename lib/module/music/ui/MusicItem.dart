import 'dart:collection';
import 'dart:math';

import 'package:exp/module/music/bean/Music.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class MusicItem extends StatefulWidget{

  int _position;
  Music _music;


  MusicItem(this._position,this._music);

  @override
  State createState() {
    return _MusicItemState();
  }
}

class _MusicItemState extends State<MusicItem>{

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text('11111111111ddddddddddddddddddddddddddddddddddddddddddddddddddd111'),
        Text('22222222222')
      ],
    );
  }
}

class ConstraintLayout extends MultiChildRenderObjectWidget{
  final List<Child> widgets;
  ConstraintLayout({Key key,this.widgets}):super(key:key,children:widgets.map((e) => e.widget).toList(growable: false));
  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ConstraintLayoutRenderObject(children: widgets);
  }
}

class _ConstraintLayoutRenderObject extends RenderBox with ContainerRenderObjectMixin<RenderBox, ConstraintLayoutParams>,
    RenderBoxContainerDefaultsMixin<RenderBox, ConstraintLayoutParams>,DebugOverflowIndicatorMixin{
  HashMap<Object,RenderBox> render = HashMap();
  List<RenderBox> renderList = List();
  List<Child> children = List();
  _ConstraintLayoutRenderObject({List<Child> children = const <Child>[]}){
    for(int i=0;i<children.length;i++){
      this.children.add(children[i]);
    }
  }
  @override
  void performLayout() {
    renderList.clear();
    var child = firstChild;
    while(child!=null){
      var lp = child.parentData as ConstraintLayoutParams;
      renderList.add(child);
      child = lp.nextSibling;
    }

    var usedWidth = 0.0;
    var maxHeight = 0.0;
    for(int i=renderList.length-1;i>=0;i--){
      var child = renderList[i];
      if(child!=firstChild){
        var box = BoxConstraints.loose(Size(constraints.maxWidth -usedWidth,constraints.maxHeight));
        child.layout(box,parentUsesSize: true);
        var lp = child.parentData as ConstraintLayoutParams;
        usedWidth += child.size.width;
        lp.offset = Offset(constraints.maxWidth - usedWidth,0);
        maxHeight = max(maxHeight, child.size.height);
      }else{
        var remain = constraints.maxWidth - usedWidth;
        child.layout(BoxConstraints.loose(Size(remain,constraints.maxHeight)),parentUsesSize: true);
        maxHeight = max(maxHeight, child.size.height);
        var width = usedWidth + child.size.width;
        size = constraints.constrain(Size(width,maxHeight));
      }
    }
    for(int i=0;i<renderList.length;i++){
      var lp = renderList[i].parentData as ConstraintLayoutParams;
      if(children[i].centerVertical){
        lp.offset = lp.offset.translate(0, (maxHeight - renderList[i].size.height)/2);
      }
      if(children[i].matchVertical){

      }
    }

  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var child = firstChild;
    while(child!=null){
      var lp = child.parentData as ConstraintLayoutParams;
      child.paint(context, offset + lp.offset);
      child = (child.parentData as ContainerBoxParentData).nextSibling;
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if(child.parentData==null||child.parentData is! ConstraintLayoutParams){
      child.parentData = ConstraintLayoutParams();
    }
  }
}
class ConstraintLayoutParams extends MultiChildLayoutParentData{
}

class Child{
  final Widget widget;
  final bool centerVertical;
  final bool matchVertical;
  Child({@required this.widget,this.centerVertical = false,this.matchVertical = false});
}