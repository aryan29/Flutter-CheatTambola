import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'provider1.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String mode = "manual";
  @override
  void initState() {
    super.initState();
    mode = Modes().mode;
    print("Coming to init of settings page");
    print(mode);
  }

  @override
  Widget build(BuildContext context) {
    // print("Rebilding");

    return Scaffold(
        floatingActionButton: Align(
          alignment: Alignment(-0.9, -0.9),
          child: FlatButton(
            child: Icon(Icons.chevron_left, color: Colors.white, size: 50),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        body: Container(
          width: double.infinity,
          child: Container(
              color: Colors.grey[900],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 100),
                  Text("Modes",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30)),
                  SizedBox(height: 200),
                  Container(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            final model =
                                Provider.of<Modes>(context, listen: false);

                            final pref = await SharedPreferences.getInstance();
                            pref.setString("mode", "manual");
                            setState(() => {mode = "manual"});
                            model.notifyRebuild("manual");
                          },
                          child: Text("Manual",
                              style: TextStyle(
                                  color: (mode == "manual")
                                      ? Colors.blue
                                      : Colors.white,
                                  fontSize: 20)),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() => {mode = "auto"});
                            final model =
                                Provider.of<Modes>(context, listen: false);
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  //  final model = Provider.of<Modes>(context, listen: false);
                                  return AlertDialog(
                                    backgroundColor:
                                        Colors.transparent.withOpacity(0.6),
                                    content: Container(
                                        height: 300,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () async {
                                                final pref =
                                                    await SharedPreferences
                                                        .getInstance();
                                                pref.setString("mode", "auto1");
                                                model.notifyRebuild("auto1");

                                                // model.notifyRebuild("auto1");
                                              },
                                              child: Text("Fast",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20)),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                print("Auto2 touched");
                                                final pref =
                                                    await SharedPreferences
                                                        .getInstance();
                                                pref.setString("mode", "auto2");
                                                model.notifyRebuild("auto2");
                                                // model.notifyRebuild("auto2");
                                              },
                                              child: Text("Medium",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20)),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                final pref =
                                                    await SharedPreferences
                                                        .getInstance();
                                                pref.setString("mode", "auto3");
                                                model.notifyRebuild("auto3");
                                                // model.notifyRebuild("auto3");
                                              },
                                              child: Text("Slow",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20)),
                                            ),
                                          ],
                                        )),
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
                                  );
                                });
                          },
                          child: Text("Automatic",
                              style: TextStyle(
                                  color: (mode == "manual")
                                      ? Colors.white
                                      : Colors.blue,
                                  fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }
}
