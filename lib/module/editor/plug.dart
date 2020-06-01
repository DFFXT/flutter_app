import 'dart:io';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plug.g.dart';

const String EMPTY_TEXT = '\u200B';
@JsonSerializable(nullable: false)
class LineData {
  static const String TYPE_TEXT = 'TEXT';
  static const String TYPE_IMAGE = 'IMAGE';
  String type = 'TEXT';
  TextData textData;
  ImageData imageData;
  int id;

  LineData(this.id, {this.type, this.textData, this.imageData});
  factory LineData.fromJson(Map<String, dynamic> json) => _$LineDataFromJson(json);
  Map<String, dynamic> toJson() => _$LineDataToJson(this);


}
@JsonSerializable(nullable: true)
class TextData {
  static const String STYLE_TEXT = "TEXT";
  static const String STYLE_H1 = "H1";
  static const String STYLE_H2 = "H2";
  static const String STYLE_OL = "OL";
  static const String STYLE_UL = "UL";
  static const String STYLE_IMAGE_DESC = "IMAGE_DESC";
  static const String STYLE_REFERENCE = "REFERENCE";
  String text = EMPTY_TEXT;
  bool center = false;
  String textColor = Colors.blueAccent.toString();
  String style = STYLE_TEXT;

  TextData({String text,this.center, this.textColor, this.style}){
    setText(text);
  }
  factory TextData.fromJson(Map<String, dynamic> json) => _$TextDataFromJson(json);
  Map<String, dynamic> toJson() => _$TextDataToJson(this);
  void setText(String text){
    if(text==null || text == ''){
      this.text = EMPTY_TEXT;
    }else if(!text.startsWith(EMPTY_TEXT)){
      this.text = EMPTY_TEXT + text;
    }else{
      this.text = text;
    }
  }
}
@JsonSerializable(nullable: true)
class ImageData {
  double height = -1;
  double width = -1;
  String image;

  ImageData(this.image, {this.width, this.height});
  factory ImageData.fromJson(Map<String, dynamic> json) => _$ImageDataFromJson(json);
  Map<String, dynamic> toJson() => _$ImageDataToJson(this);
}

class Format {
  String image;
  String text;
  GestureTapCallback callback;

  Format({this.image, this.text, this.callback});
}