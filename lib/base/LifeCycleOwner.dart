import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

typedef Observer(AppLifecycleState state);

///state 一个页面如果要能够被监听state时继承
abstract class LifeCycleOwnerState extends State<StatefulWidget>
    with WidgetsBindingObserver {
  LifeCycleOwnerState() {
    WidgetsBinding.instance.addObserver(this);
  }

  ObserverList<Observer> _observer;

  @mustCallSuper
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
    if (_observer != null) {
      for (Observer observer in _observer) {
        observer(state);
      }
    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("deactive");
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    print("deispose");
  }

  void addObserver(observer(AppLifecycleState state)) {
    if (_observer == null) {
      _observer = ObserverList();
    }
    if (!_observer.contains(observer)) {
      _observer.add(observer);
    }
  }
}

enum LifecycleState {
  resumed,
  inactive,
  paused,
  detached,
  stop
}
