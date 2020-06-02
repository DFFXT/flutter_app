
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:picker/picker.dart';

abstract class Operation{

  ui.Image _image;

  void draw(Canvas canvas,Size size);

  void tryImmutable(Size size);
}

class Lines extends Operation{
  var _lines = List<Offset>();
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
  
  var rect = Rect.fromCenter(center: Offset(0,0),width:200,height:40);
  var paint = Paint();


  @override
  void tryImmutable(Size size) async{
    if(_image!=null)return;
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas=Canvas(recorder);
    canvas.drawColor(Colors.white, BlendMode.src);
    draw(canvas, size);
    _image= await recorder.endRecording().toImage(size.width.toInt(), size.height.toInt());
    //ImageGallerySaver.saveImage((await _image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List());
  }

  @override
  void draw(Canvas canvas,Size size) {
    if(_image!=null){
      canvas.drawImage(_image, Offset(0,0), paint);
    }else{
      paint.color = Colors.deepOrange;
      paint.style = PaintingStyle.stroke;
      canvas.save();
      canvas.translate(size.width/2,size.height/2);
      canvas.translate(-100, 0);
      for(double i=0;i<180;i+=0.4){
        if(i<90){
          canvas.translate(0, -1);
        }else{
          canvas.translate(0, 1);
        }

        canvas.rotate(pi/180);
        canvas.drawOval(Rect.fromCenter(center: Offset(0,0),width:(300+i),height:40+i), paint);
      }
      canvas.restore();
    }


  }
}

class Day with ChangeNotifier{
  int a=0;
  void add(int a){
    this.a=a;
    notifyListeners();
  }
}