import 'dart:collection';

import 'package:exp/base/LifeCycleOwner.dart';
import 'package:flutter/services.dart';

typedef void ChannelCallback(String method, dynamic argument);

class BasePage {
  static MethodChannel _channel = MethodChannel("intent");

  static BasePage _instance;

  List<ChannelObserver> _observer;

  BasePage._init();

  static BasePage getInstance() {
    if (_instance == null) {
      _instance = new BasePage._init();
      _instance._listen();
    }
    return _instance;
  }

  void _listen() {
    // ignore: missing_return
    _channel.setMethodCallHandler((MethodCall call) {
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
    return _channel.invokeMethod(method,argument.value());
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