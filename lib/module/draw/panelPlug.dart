
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

abstract class Operation{
  void draw(Canvas canvas,Size size);
}

class Lines extends Operation{
  var _lines = List<Offset>();
  ui.Image _image;
  Paint paint;
  int immutableLimit;
  Lines({this.paint,this.immutableLimit = 10}){
    if(paint==null){
      paint = Paint();
    }
  }

  void addOffset(Offset offset){
    this._lines.add(offset);
  }

  void tryImmutable(Size size) async{
    print(_lines.length);
    print(immutableLimit);
    if(_lines.length > this.immutableLimit){
      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas canvas=Canvas(recorder);
      canvas.drawColor(Colors.white, BlendMode.src);
      draw(canvas, size);
      _image= await recorder.endRecording().toImage(size.width.toInt(), size.height.toInt());
      ImageGallerySaver.saveImage((await _image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List());
    }
  }


  @override
  void draw(Canvas canvas,Size size) {
    print("drawSize $size");
    if(_image!=null){
      canvas.drawImage(_image, Offset(0,0), paint);
    }else{
      for(int i=1;i<_lines.length;i++){
        canvas.drawLine(_lines[i-1], _lines[i], paint);
      }
    }
  }
}

class Oval extends Operation{
  
  var rect = Rect.fromCenter(center: Offset(0,0),width:200,height:12);
  var paint = Paint();
  
  @override
  void draw(Canvas canvas,Size size) {
    paint.style = PaintingStyle.stroke;
    canvas.save();
    canvas.translate(size.width/2,size.height/2);
    for(int i=0;i<180;i++){

      canvas.rotate(pi/180);
      canvas.drawOval(rect, paint);
    }
    canvas.restore();

  }
}

class Day with ChangeNotifier{
  int a=0;
  void add(int a){
    this.a=a;
    notifyListeners();
  }
}