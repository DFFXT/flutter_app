import 'package:flutter/cupertino.dart';

class GlobalParams extends ChangeNotifier{
  var _state = 1;
  var f=0;
  int get state => _state;

  void setState(int state){
    _state=state;
    notifyListeners();
  }

}