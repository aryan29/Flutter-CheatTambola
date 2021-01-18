import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import "main.dart";

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment(0, 0.8),
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage("images/intro.png"))),
          child: Container(
            height: 100,
            width: 300,
            child: Column(
              children: [
                FittedBox(
                  child: FloatingActionButton.extended(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      icon: Icon(Icons.arrow_right),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 500),
                                type: PageTransitionType.rightToLeft,
                                child: MyHomePage(title: "Tambola Game")));
                      },
                      label: Text("Next")),
                ),
                SizedBox(height: 10),
                Container(
                    child: Text(
                        "Long Press the settings icon and enter 123456 to fix numbers",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic)))
              ],
            ),
          )),
    );
  }
}
