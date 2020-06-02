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
  ConstraintLayout({Key key,List<Child> children}):super(key:key,children:children);
  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ConstraintLayoutRenderObject(children: children);
  }
  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
  }
}

class _ConstraintLayoutRenderObject extends RenderBox with ContainerRenderObjectMixin<RenderBox, ConstraintLayoutParams>,
    RenderBoxContainerDefaultsMixin<RenderBox, ConstraintLayoutParams>,DebugOverflowIndicatorMixin{
  HashMap<Object,RenderBox> render = HashMap();
  List<RenderBox> renderList = List();
  HashMap<Object,Child> children = HashMap();
  _ConstraintLayoutRenderObject({List<Child> children = const <Child>[]}){
    for(int i=0;i<children.length;i++){
      this.children[children[i].id] = children[i];
    }
  }
  bool relayout = true;
  @override
  void performLayout() {

    var child = firstChild;
    var lastChild = (child.parentData as ContainerBoxParentData).nextSibling as RenderBox;
    if(lastChild!=null){
      var box = BoxConstraints.loose(Size(constraints.maxWidth,constraints.maxHeight));
      lastChild.layout(box,parentUsesSize: true);
      var remain = box.maxWidth - lastChild.size.width;
      child.layout(BoxConstraints.loose(Size(remain,constraints.maxHeight)),parentUsesSize: true);
      var width = lastChild.size.width + child.size.width;
      var height = max(lastChild.size.height , child.size.height);
      size = constraints.constrain(Size(width,height));
      print(child.size);
      print(lastChild.size);
      print(size);
      (lastChild.parentData as ConstraintLayoutParams).offset = Offset(size.width-lastChild.size.width,0);
    }


  }

  @override
  void markNeedsLayout() {
    relayout = true;
    super.markNeedsLayout();
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

enum ConstraintType{
  SHOW_FULL
}

abstract class Constraint{
  ConstraintType type;
  Object id;
}

class ShowFull extends Constraint{
  ShowFull(Object id){
    this.type = ConstraintType.SHOW_FULL;
    this.id=id;
  }
}

class Child extends LayoutId{
  final Object id;
  final List<Constraint> constraint;
  Child({@required this.id, Widget widget,this.constraint = const <Constraint>[]}):super(id:id,child:widget);
}