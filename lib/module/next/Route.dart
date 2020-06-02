import 'package:flutter/cupertino.dart';

typedef Widget WidgetCreate();

class RouteItem {
  String name;
  WidgetCreate widgetCreate;

  RouteItem(this.name, this.widgetCreate) {
    assert(widgetCreate != null);
  }
}
