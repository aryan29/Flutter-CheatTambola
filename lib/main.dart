import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tambola Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Tambola Game'),
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
  String cur = "46";
  HashMap mp = new HashMap<int, int>();
  _MyHomePageState() {
    for (int i = 1; i <= 100; i++) {
      mp[i] = 0;
    }
  }

  void random_number() {
    var rng = new Random();
    int x = 1 + rng.nextInt(100);
    print(x);
    print(mp[x]);
    if (mp[x] == 0) {
      rng.nextInt(100);
      mp[x] = 1;
      setState(() {
        mp[x] = 1;
        cur = "$x ";
      });
    } else {
      print("Repeated");
      random_number();
    }
  }

  void init() {
    for (int i = 1; i <= 100; i++) {
      mp[i] = 0;
      setState(() {
        mp[i] = 0;
        cur = "";
      });
    }
  }

  Color getcolor(int x) {
    if (mp[x] == 1)
      return Colors.red;
    else
      return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 50.0,
                width: double.infinity,
                child: Text(
                  cur,
                  style: TextStyle(
                    fontSize: 50.0,
                    fontFamily: "Horizon",
                  ),
                  textAlign: TextAlign.center,
                )),
            Padding(padding: EdgeInsets.only(bottom: 30.0)),
            RichText(
              text: TextSpan(
                style: TextStyle(
                    color: Colors.blue,
                    letterSpacing: 1.0,
                    wordSpacing: 6.0,
                    fontSize: 20.0),
                children: <TextSpan>[
                  for (int i = 0; i <= 9; i++)
                    for (int j = 1; j <= 10; j++)
                      () {
                        if ((i * 10 + j) <= 9)
                          return TextSpan(
                              text: "${i * 10 + j}  ",
                              style: TextStyle(color: getcolor(i * 10 + j)));
                        if ((i * 10 + j) % 10 != 0)
                          return TextSpan(
                              text: "${i * 10 + j} ",
                              style: TextStyle(color: getcolor(i * 10 + j)));
                        else
                          return TextSpan(
                              text: "${i * 10 + j}\n",
                              style: TextStyle(color: getcolor(i * 10 + j)));
                      }()
                ],
              ),
            ),
            FloatingActionButton(
              autofocus: true,
              onPressed: random_number,
              tooltip: 'Increment',
              child: Icon(Icons.navigate_next),
            ),
            SizedBox(height: 20),
            Text(
              'Press It',
              style: Theme.of(context).textTheme.display1,
            ),
            SizedBox(height: 20),
            Container(
              height:50.0,
              width:200.0,
              child:FittedBox(
              child:FlatButton(
              autofocus: true,
              onPressed: init,
              child: Text("Start New Game"),
            ),
              )
            )
          ],
        ),
      ),
    );
  }
}
