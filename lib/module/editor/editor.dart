import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:convert';

import 'package:exp/base/LifeCycleOwner.dart';
import 'package:exp/base/TopBar.dart';
import 'package:exp/module/editor/plug.dart';
import 'package:exp/util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:picker/picker.dart';
class EditorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: TopBar(),
      body: _Editor(),
    );
  }
}

class _Editor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditorState();
  }
}

class _EditorState extends LifeCycleOwnerState {
  var lineData = List<LineData>();
  Future<List<LineData>> localLineFuture;
  List<LineData> localData;
  var styleList = List<Format>();
  var scrollController = ItemScrollController();
  var focusId = -1;
  var fn = HashMap<int, FocusNode>();
  var tc = HashMap<int, TextEditingController>();
  var idOffset = 0;

  @override
  void initState() {
    localLineFuture = _readSave();
    _addLine(LineData.TYPE_TEXT, textData:TextData(text:'first line'));
    styleList.add(Format(
        image: "assets/uicon.jpg",
        text: "换行",
        callback: () {
          if (focusId >= 0) {
            fn[focusId]?.unfocus();
            groupNode?.requestFocus();
            setState(() {
              var index = CollectionsUtil.indexOf<LineData>(lineData, (it) {
                    return it.id == focusId;
                  }) +
                  1;
              _addLine(LineData.TYPE_TEXT, textData: TextData(), index: index);
            });
          }
        }));
    styleList.add(Format(
        image: "assets/uicon.jpg",
        callback: () {
          _pickImage();
        }));

    styleList.add(Format(image: "assets/uicon.jpg",text: 'H1',callback: (){
      var item=_findFocusItem();
      if(item!=null&&item.textData.style!=TextData.STYLE_IMAGE_DESC&&item.textData.style!=TextData.STYLE_H1){
        setState(() {
          item.textData.style = TextData.STYLE_H1;
        });
      }
    }));
    styleList.add(Format(image: "assets/uicon.jpg",text: 'H2',callback: (){
      var item=_findFocusItem();
      if(item!=null&&item.textData.style!=TextData.STYLE_IMAGE_DESC&&item.textData.style!=TextData.STYLE_H2){
        reFocus=true;
        setState(() {
          item.textData.style = TextData.STYLE_H2;
        });
      }
    }));
    styleList.add(Format(image: "assets/uicon.jpg",text: 'OL',callback: (){
      var item=_findFocusItem();
      if(item!=null&&item.textData.style!=TextData.STYLE_IMAGE_DESC&&item.textData.style!=TextData.STYLE_OL){
        setState(() {
          item.textData.style = TextData.STYLE_OL;
        });
      }
    }));
    styleList.add(Format(image: "assets/uicon.jpg",text: 'UL',callback: (){
      var item=_findFocusItem();
      if(item!=null&&item.textData.style!=TextData.STYLE_IMAGE_DESC&&item.textData.style!=TextData.STYLE_UL){
        setState(() {
          item.textData.style = TextData.STYLE_UL;
        });
      }
    }));
    styleList.add(Format(image: "assets/uicon.jpg",text: 'TEXT',callback: (){
      var item=_findFocusItem();
      if(item!=null&&item.textData.style!=TextData.STYLE_IMAGE_DESC&&item.textData.style!=TextData.STYLE_TEXT){
        setState(() {
          item.textData.style = TextData.STYLE_TEXT;
        });
      }
    }));
    super.initState();
  }

  LineData _findFocusItem(){
    return CollectionsUtil.find<LineData>(lineData, (item)=>item.id == focusId);
  }


  var reFocus = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('object');
    if(reFocus){
      reFocus=false;
      fn[focusId]?.unfocus();
      fn[focusId]?.requestFocus();
    }
  }

  void _pickImage() async {
    File file = await Picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() {
      var index = CollectionsUtil.indexOf<LineData>(lineData, (it) {
        return it.id == focusId;
      });
      if(index<0){
        index = 0;
      }
      var item = lineData[index];
      if(item.type == LineData.TYPE_TEXT&&item.textData.text == EMPTY_TEXT){
        item.type = LineData.TYPE_IMAGE;
        item.imageData = ImageData(file.path);
        _addLine(LineData.TYPE_TEXT, textData: TextData(style: TextData.STYLE_IMAGE_DESC) ,index: index+1,autoFocus: true);
      }else{
        _addLine(LineData.TYPE_IMAGE, imageData:ImageData(file.path),index: index+1,autoFocus: false);
        _addLine(LineData.TYPE_TEXT, textData: TextData(style: TextData.STYLE_IMAGE_DESC),);
      }


    });
  }


  bool _canDelete(int index){
    if(lineData.length==1) return false;
    if(index>0){
      var preItem = lineData[index-1];
      if(preItem.type == LineData.TYPE_IMAGE || (preItem.type ==LineData.TYPE_TEXT&&preItem.textData.style==TextData.STYLE_IMAGE_DESC)){
        return false;
      }
    }
    return true;
  }

  void _removeImage(int index){
    if(lineData[index].type==LineData.TYPE_IMAGE){
      if(index+1<lineData.length && lineData[index+1].textData.style == TextData.STYLE_IMAGE_DESC){
        _removeAt(index+1);
      }
      _removeAt(index);
    }
  }

  void _removeAt(int index) {
    fn.remove(lineData[index].id);
    tc.remove(lineData[index].id);
    if (focusId == lineData[index].id) {
      bool findFocus = false;
      for (int i = index - 1; i >= 0; i--) {
        if (lineData[i].type == LineData.TYPE_TEXT) {
          focusId = lineData[i].id;
          _focusId(focusId);
          print(lineData[i].textData.text);
          findFocus = true;
          break;
        }
      }
      if (!findFocus) {
        for (int i = index + 1; i < lineData.length; i++) {
          if (lineData[i].type == LineData.TYPE_TEXT) {
            focusId = lineData[i].id;
            _focusId(focusId);
            print(lineData[i].textData.text);
            findFocus = true;
            break;
          }
        }
      }
    }
    lineData.removeAt(index);
  }

  void _addLine(String type, {ImageData imageData, TextData textData, int index,bool autoFocus=true}) {
    if (index == null) {
      index = lineData.length;
    }
    focusId = idOffset + 1;
    lineData.insert(
        index,
        LineData(idOffset += 1,
            type: type, imageData: imageData, textData: textData));
    if(autoFocus){
      _focusId(focusId);
    }
  }

  void _focusId(int focusId) async {
    Future.delayed(Duration(milliseconds: 100), () {
      groupNode.unfocus();
      fn[focusId]?.requestFocus();
    });
  }

  var groupNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: localLineFuture,
      builder: (ctx,data){
        if(data.connectionState==ConnectionState.done){

          if(data.data != null && localData == null){//第一次读取
            lineData = data.data;
            localData = data.data;
            for(int i=0;i<localData.length;i++){//重置IdOffset
              localData[i].id = idOffset+=1;
            }
          }
          if(localData!=null){
            lineData = localData;
          }
          return Column(
            children: <Widget>[
              Container(
                height: 0,
                child: TextField(
                  //保持键盘的存在
                  focusNode: groupNode,
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: lineData.length,
                    itemBuilder: (ctx, index) {
                      if (index >= lineData.length) return null;

                      var item = lineData[index];

                      if (item.type == LineData.TYPE_TEXT) {
                        if (fn[item.id] == null) {
                          fn[item.id] = FocusNode();
                        }
                        FocusNode node = fn[item.id];
                        node.addListener(() {
                          if (node.hasFocus) {
                            focusId = item.id;
                          }
                        });
                        print(item.textData.text);

                        double textSize = 16;
                        FontWeight weight = FontWeight.w400;
                        Color color = Colors.black;
                        String prefix='';
                        TextAlign textAlign = TextAlign.start;
                        int maxLines;
                        switch(item.textData.style){
                          case TextData.STYLE_TEXT:
                            break;
                          case TextData.STYLE_H1:
                            weight = FontWeight.w500;
                            textSize = 24;
                            break;
                          case TextData.STYLE_H2:
                            weight = FontWeight.w500;
                            textSize = 18;
                            break;
                          case TextData.STYLE_OL:
                            prefix = '1.';
                            break;
                          case TextData.STYLE_UL:
                            prefix = '· ';
                            break;
                          case TextData.STYLE_IMAGE_DESC:
                            textAlign = TextAlign.center;
                            textSize = 12;
                            maxLines = 1;
                            break;
                        }

                        if(tc[item.id]==null){
                          tc[item.id] = TextEditingController(text: item.textData.text);
                        }

                        return
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(margin: EdgeInsets.only(left: 8,top: 8,right: 8),
                                child: Text(prefix,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                              ),
                              Expanded(
                                child: TextField(
                                  focusNode: node,
                                  textAlign:textAlign,
                                  onChanged: (text) {
                                    print(text.length);
                                    if (text == '') {
                                      if(_canDelete(index)){
                                        fn[focusId]?.unfocus();
                                        groupNode?.requestFocus();
                                        setState(() {
                                          //todo
                                          _removeAt(index);
                                        });
                                      }
                                    }
                                    item.textData.setText(text);
                                  },
                                  maxLines: maxLines,
                                  style: TextStyle(fontSize: textSize,fontWeight: weight,color: color),
                                  controller: tc[item.id],
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      isDense: true),
                                ),
                              )

                            ],
                          )
                        ;
                      } else if (item.type == LineData.TYPE_IMAGE) {
                        return UnconstrainedBox(
                          child: Container(
                            constraints: BoxConstraints.loose(Size(
                                MediaQuery.of(context).size.width,
                                double.infinity)),
                            child: FittedBox(
                              child: Stack(
                                alignment: Alignment(1, -1),
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {},
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints.loose(Size(
                                          MediaQuery.of(context).size.width,
                                          double.infinity)),
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Image.file(
                                          File(item.imageData.image),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0, -1),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            child: AlertDialog(
                                              title: Text("删除？"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    setState(() {
                                                      _removeImage(index);
                                                    });
                                                  },
                                                  child: Text("删除"),
                                                ),
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("保留"),
                                                )
                                              ],
                                            ));
                                        /* setState(() {
                                      lineData.removeAt(index);
                                    });*/
                                      },
                                      child: Icon(Icons.delete),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return null;
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: styleList.length,
                        itemBuilder: (ctx, index) {
                          var item = styleList[index];
                          Widget child;
                          if (item.text == null) {
                            child = Image.asset(
                              styleList[index].image,
                            );
                          } else {
                            child = Stack(
                              children: <Widget>[
                                Align(
                                  child: Image.asset(
                                    styleList[index].image,
                                    fit: BoxFit.scaleDown,
                                    width: 20,
                                    height: 20,
                                  ),
                                  alignment: Alignment(0, -1),
                                ),
                                Align(
                                  alignment: Alignment(0, 1),
                                  child: Text(
                                    item.text,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                )
                              ],
                            );
                          }
                          return GestureDetector(
                            onTap: styleList[index].callback,
                            child: Container(
                              color: Colors.deepOrange,
                              padding: EdgeInsets.all(4),
                              width: 40,
                              height: 40,
                              child: child,
                            ),
                          );
                        }),
                  )
                ],
              )
            ],
          );
        }
        else{
          return Text("wait");
        }

      },
    );
  }


  @override
  void dispose() {
    super.dispose();
    _save();
  }

  void _save() async {
    Directory directory = await getTemporaryDirectory();
    var saveFile = new File(directory.path + "/save.txt");
    if (!await saveFile.exists()) {
      saveFile.create();
    }
    print(jsonEncode(lineData));
    saveFile.writeAsString(jsonEncode(lineData));
  }
  
  Future<List<LineData>> _readSave() async {
    print(await Permission.storage.isUndetermined);
    if(await Permission.storage.isUndetermined){
      if((await Permission.storage.request()).isRestricted){

      }
    }
    Directory directory = await getTemporaryDirectory();
    var saveFile = new File(directory.path + "/save.txt");
    if (!await saveFile.exists()) {
      return null;
    }
    List res = jsonDecode(await saveFile.readAsString());
    return res.map((v){
      return LineData.fromJson(v);
    }).toList();
  }
}

class _ImageDataWidget extends StatefulWidget {
  final ImageData imageData;

  _ImageDataWidget(this.imageData);

  @override
  State<StatefulWidget> createState() {
    return _ImageDataState(imageData);
  }
}

class _ImageDataState extends State {
  _ImageDataState(this.imageData);

  ImageData imageData;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        width: 100,
        height: 100,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Image.file(File(imageData.image)),
            ),
            Align(
              alignment: Alignment(1, -1),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.delete),
              ),
            )
          ],
        ),
      ),
    );
  }
}





