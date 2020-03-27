import 'package:flutter/material.dart';
import '../main.dart';

class EmptyPage extends StatelessWidget {
  List<int> li = [1,3];//Generate Some Random List to Get Some Extra Values
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
  }

  TextEditingController mycontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 200,
          ),
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
                Navigator.pop(context);
              },
              child: Text("Go Back")),
        ],
      )),
    );
  }
}
