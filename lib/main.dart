import 'package:exp/base/BasePage.dart';
import 'package:exp/base/LifeCycleOwner.dart';
import 'package:exp/module/next/Page2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return HomeState();
  }
}

class HomeState extends LifeCycleOwnerState{

  HomeState(){
    BasePage.getInstance().invoke("test",ChannelArgument("123","ddddddd")).then((onValue){
      print(onValue);
    },onError: (e){
      print("then error $e");
    }).whenComplete((){
      print("Complete");
    });

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Fltter Demo Home Page'),
      routes: <String,WidgetBuilder>{
        'page2': (ctx){return Page2();}
      },
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            GestureDetector(
              onTapUp: (e){
                Navigator.push(context, new MaterialPageRoute(builder: (ctx){
                  return Page2();
                }));
              },
              child: Text(
                '$_counter',
                style: Theme.of(context).textTheme.display1,
              ),
            )
            ,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
