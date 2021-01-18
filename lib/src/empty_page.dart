import 'package:flutter/material.dart';
import 'dart:math';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmptyPage extends StatelessWidget {
  List<int> li = []; //Generate Some Random List to Get Some Extra Values
  void setli() {
    print("Coming to Converter");
    String z = "";
    String s = mycontroller.text;
    for (int i = 0; i < s.length; i++) {
      if (s[i] != ',') {
        z += s[i];
      } else {
        li.add(int.parse(z));
        z = "";
      }
    }
    if (z != "") li.add(int.parse(z));
    print(li);
    int sz = li.length;
    var rng = new Random();
    for (int i = 1; i <= sz * 3; i++) {
      int jj = rng.nextInt(90);
      li.add(jj);
    }
    li = li.toSet().toList();
    print(li);
  }

  TextEditingController mycontroller = new TextEditingController();
  TextEditingController mycontroller1 = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Column(children: [
              Container(child: Text("Enter numbers in your ticket here")),
              Container(
                width: 300,
                child: TextField(
                    controller: mycontroller,
                    style: TextStyle(letterSpacing: 4.0),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      icon: Icon(Icons.confirmation_number),
                      hintText: "Ex:- 1,2,3",
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    await setli();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MyHomePage(title: "Tambola", cheatData: li)));
                  },
                  child: Text("Save")),
            ]),
            SizedBox(
              height: 20,
            ),
            FlatButton(
                color: Colors.blue, onPressed: () {}, child: Text("Clear")),
            SizedBox(
              height: 20,
            ),
            FlatButton(
                onPressed: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                },
                child: Text("Go Back")),
            SizedBox(
              height: 100,
            ),
            Column(children: [
              Container(child: Text("Enter your new password here")),
              Container(
                width: 300,
                child: TextField(
                    controller: mycontroller1,
                    style: TextStyle(letterSpacing: 4.0),
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    decoration: InputDecoration(
                      icon: Icon(Icons.confirmation_number),
                      hintText: "Ex:- 123456",
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    if (mycontroller1.text.length == 6)
                      pref.setString("password", mycontroller1.text);
                  },
                  child: Text("Save")),
            ])
          ],
        )),
      ),
    );
  }
}
