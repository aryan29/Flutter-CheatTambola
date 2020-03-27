import 'dart:collection';
import 'dart:async';
import 'package:flutter/material.dart';
import 'src/empty_page.dart';
import 'dart:math';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped }
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
  final String title;
  List cheatData;
  MyHomePage({Key key, this.title, this.cheatData}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState(cheatData: cheatData);
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterTts flutterTts = new FlutterTts();

  TtsState ttsState = TtsState.stopped;
  List cheatData;
  _MyHomePageState({this.cheatData});
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  String cur = "";
  HashMap mp = new HashMap<int, int>();
  Future _speak(int z) async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setSpeechRate(0.4);
    var result;
    if (z < 9)
      result = await flutterTts.speak("Only Number  $z");
    else
      result = await flutterTts.speak("$z");
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  _showLockScreen(BuildContext context, {bool opaque}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            title: 'Enter App Passcode',
            passwordEnteredCallback: _onPasscodeEntered,
            cancelLocalizedText: 'Cancel',
            deleteLocalizedText: 'Delete',
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
          ),
        ));
  }

  Future<void> _onPasscodeEntered(String enteredPasscode) {
    bool isValid = '123456' == enteredPasscode;
    if (isValid) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return EmptyPage();
      }));
    }
  }

  _onPasscodeCancelled() {}
  void random_number() {
    var rng = new Random();
    int x;
    try {
      if (cheatData.length != 0) {
        x = cheatData[rng.nextInt(cheatData.length)];
        cheatData.remove(x);
      } else {
        x = 1 + rng.nextInt(100);
      }
    } catch (e) {
      x = 1 + rng.nextInt(100);
    }
    print(x);
    print(mp[x]);
    if (mp[x] == 0) {
      _speak(x);
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
    print(cheatData);
    print("Coming to init");
    cheatData.clear();
    //print(cheatData);
    for (int i = 1; i <= 100; i++) {
      mp[i] = 0;
      setState(() {
        mp[i] = 0;
        cur = "";
      });
    }
  }

  @override
  void initState() {
    print("Coming to init state");
    super.initState();
    // cheatData.clear();
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
              heroTag: "btn1",
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
            SizedBox(height: 40),
            Container(
                height: 50.0,
                width: 200.0,
                child: FittedBox(
                  child: FlatButton(
                    autofocus: true,
                    onPressed: init,
                    child: Text("Start New Game"),
                  ),
                )),
            FloatingActionButton(
              heroTag: "btn2",
              autofocus: true,
              onPressed: () => _showLockScreen(context, opaque: false),
              tooltip: 'ChangeScreen',
              child: Icon(Icons.weekend),
            ),
          ],
        ),
      ),
    );
  }
}
