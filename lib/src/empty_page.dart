import 'package:flutter/material.dart';
import '../main.dart';

class EmptyPage extends StatelessWidget {
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
              onPressed: () {
                final sec = MyHomePage();
                sec.printing(mycontroller.text);
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
