import 'dart:collection';

import 'package:exp/base/LifeCycleOwner.dart';
import 'package:flutter/services.dart';

typedef void ChannelCallback(String method, dynamic argument);

class ChannelUtil {
  static Map<ChannelType,MethodChannel> _channel = HashMap();

  static Map<ChannelType,ChannelUtil> _instance = HashMap();

  MethodChannel __channel;

  List<ChannelObserver> _observer;

  ChannelUtil._init(ChannelType type){
    if(!_channel.containsKey(type)){
      __channel = MethodChannel(type.toString());
      _channel[type] = __channel;
    }
  }

  static ChannelUtil getInstance(ChannelType type) {
    if (_instance[type] == null) {
      var ins = new ChannelUtil._init(type);
      _instance[type]=ins;
      _instance[type]._listen();
    }
    return _instance[type];
  }

  void _listen() {
    // ignore: missing_return
    __channel.setMethodCallHandler((MethodCall call) {
      print("sdfsafsdfffffffffffff");
      ChannelArgument argument = call.arguments;
      for(ChannelObserver observer in _observer){
        if(observer.flag == argument.flag){
          observer.callback(call.method,argument.argument);
        }
      }
    });
  }

  void listen(ChannelObserver observer) {
    if (_observer == null) {
      _observer = List();
    }
    if(!_observer.contains(observer)){
      _observer.add(observer);
    }
  }
  
  Future<dynamic> invoke(String method, ChannelArgument argument){
    return __channel.invokeMethod(method,argument.value());
  }
}

class ChannelObserver {
  LifeCycleOwnerState lifeCycleOwnerWidget;
  String flag;
  ChannelCallback callback;

  ChannelObserver(this.lifeCycleOwnerWidget, this.flag, this.callback);
}

class ChannelArgument{
  final String flag;
  final dynamic argument;
  const ChannelArgument([this.flag,this.argument]);
  dynamic value() {
    return {"flag":flag,"argument":argument};
  }
}

enum ChannelType{
  INTENT,KEYBOARD
}

class KeyBoard{
  void press(String method, dynamic argument){

  }
}