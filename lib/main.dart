import 'dart:collection';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tambola/first.dart';
import 'settingPage.dart';
import 'src/empty_page.dart';
import 'dart:math';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'provider1.dart';
import 'package:page_transition/page_transition.dart';

int initScreen = 0;
enum TtsState { playing, stopped }

SharedPreferences pref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pref = await SharedPreferences.getInstance();
  initScreen = pref.getInt("initScreen");
  pref.setInt("initScreen", 1);
  runApp(ChangeNotifierProvider(
      create: (_) => Modes(), child: MaterialApp(home: new MyApp())));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Building page again");
    return MaterialApp(
        title: 'Tambola Game',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: (initScreen == 0 || initScreen == null)
            ? FirstScreen()
            : MyHomePage(title: 'Tambola Game'));
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
  String mode;
  bool paused = true;
  int gap = -1;

  TtsState ttsState = TtsState.stopped;
  List cheatData;
  _MyHomePageState({this.cheatData});
  // ignore: close_sinks
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

  // ignore: missing_return
  Future<void> _onPasscodeEntered(String enteredPasscode) {
    bool isValid;
    if (!pref.containsKey("password"))
      isValid = '123456' == enteredPasscode;
    else
      isValid = pref.getString("password") == enteredPasscode;
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
        // print("here");
        x = cheatData[rng.nextInt(cheatData.length)];
        cheatData.remove(x);
      } else {
        // print("o here");
        x = 1 + rng.nextInt(90);
      }
    } catch (e) {
      x = 1 + rng.nextInt(90);
    }
    print(x);
    if (mp[x] == 0) {
      _speak(x);
      rng.nextInt(90);
      mp[x] = 1;
      setState(() {
        mp[x] = 1;
        cur = "$x ";
      });
    } else {
      // print("Repeated");
      random_number();
    }
  }

  void init() {
    if (timer != null) timer.cancel();
    print(cheatData);
    print("Coming to init");
    setState(() {
      paused = true;
      cheatData = [];
    });
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
    mode = pref.getString("mode");
    print("Coming to init state");
    paused = true;
    super.initState();
    // cheatData = [];
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
      return Colors.white;
  }

  getlast(int i) {
    // print(mp[i]);
    if (mp[i] == 1) {
      return Container(
          padding: EdgeInsets.all(5),
          child: Center(
            child: Text(i.toString(),
                style: TextStyle(color: Colors.white, fontSize: 40)),
          ));
    } else
      return Container();
  }

  Timer timer;
  getModeButton(String mode) {
    if (mode == "manual") {
      return FlatButton(
          autofocus: true,
          onPressed: random_number,
          child: Text("Next",
              style: TextStyle(color: Colors.white, fontSize: 30)));
    } else {
      // paused = true;
      if (mode == "auto1") {
        gap = 3;
      } else if (mode == "auto2") {
        gap = 6;
      } else {
        gap = 10;
      }
      return FlatButton(
          autofocus: true,
          onPressed: () {
            if (paused == true) {
              setState(() => paused = false);
              timer = Timer.periodic(Duration(seconds: gap), (timer) {
                if (paused == false) random_number();
              });
            } else {
              timer.cancel();
              setState(() {
                paused = true;
              });
            }
          },
          child: (paused == false)
              ? Icon(Icons.pause, color: Colors.white, size: 50)
              : Icon(Icons.play_arrow, color: Colors.white, size: 50));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Align(
        alignment: Alignment(0.9, -0.9),
        child: GestureDetector(
          onLongPress: () {
            return _showLockScreen(context, opaque: false);
          },
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: Settings(),
                    duration: Duration(milliseconds: 500),
                    reverseDuration: Duration(milliseconds: 500),
                    type: PageTransitionType.bottomToTop));
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => Settings()));
          },
          child: Icon(Icons.settings, size: 40, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Container(
        color: Colors.grey[900],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: 50.0,
                  width: double.infinity,
                  child: Text(
                    cur,
                    style: TextStyle(
                      fontSize: 45.0,
                      fontFamily: "Horizon",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )),
              Padding(padding: EdgeInsets.only(bottom: 30.0)),
              Container(
                  height: height * 0.4,
                  width: width * 0.9,
                  child: Center(
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 10,
                      childAspectRatio: width * 0.9 / (height * 0.4),
                      children: <Widget>[
                        for (int i = 1; i <= 90; i++)
                          Center(
                            child: Container(
                                child: Text(i.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: getcolor(i)))),
                          )
                      ],
                    ),
                  )),
              SizedBox(height: 20),
              Container(
                child: Consumer<Modes>(
                  builder: (context, myModel, child) {
                    print("Hey I am getting Notified");
                    return getModeButton(myModel.mode);
                  },
                ),
              ),
              SizedBox(height: 40),
              Align(
                alignment: FractionalOffset.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                        autofocus: true,
                        onPressed: init,
                        child: Text("New Game",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20))),
                    FlatButton(
                        autofocus: true,
                        onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    Colors.transparent.withOpacity(0.6),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.white,
                                        size: 30,
                                      ))
                                ],
                                content: Container(
                                    height: height,
                                    width: width,
                                    child: ListView.builder(
                                        itemCount: 90,
                                        itemBuilder: (context, i) {
                                          return getlast(i + 1);
                                        })),
                              );
                            }),
                        child: Text("Last numbers",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
