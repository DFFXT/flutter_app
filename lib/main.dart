import 'package:exp/base/BasePage.dart';
import 'package:exp/base/LifeCycleOwner.dart';
import 'package:exp/module/next/LandingPage.dart';
import 'package:exp/module/next/Page2.dart';
import 'package:exp/module/next/ScrollablePositionedListPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    ChannelUtil.getInstance(ChannelType.INTENT).invoke("test",ChannelArgument("123","ddddddd")).then((onValue){
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
    var node = FocusNode();
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
            GestureDetector(
              onTapUp: (e){
                print("---> ${e.globalPosition.dx}");
              },
              child: Container(
                color: Colors.red,
                margin: EdgeInsets.all(20),
                child: Material(
                  elevation: 10,
                  child: Text("xxxxxxxxx"),
                )
            )
            )
            ,

            RawKeyboardListener(
              focusNode: FocusNode() ,
              onKey: (e){
                print(e);
              },
              child: TextField(
                onChanged: (text) {

                },
                maxLines: null,
                decoration: InputDecoration(
                    prefix: GestureDetector(
                      onTap: () {
                        setState(() {
                          FocusScope.of(context).requestFocus();
                        });
                      },
                      child: Container(
                        width: 10,
                        height: 10,
                        margin: EdgeInsets.only(left:4,right: 10),
                        color: Colors.deepOrange,
                        child: Icon(Icons.minimize,size: 10,),
                      ),
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true),
              ),
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            GestureDetector(
              onTapUp: (e){
                Navigator.push(context, new MaterialPageRoute(builder: (ctx){
                  return LandingPage();
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
        child: Image.asset("assets/icon_kg.png"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
