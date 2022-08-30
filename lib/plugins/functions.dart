
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../board.dart';

showAlertDialog(BuildContext context, String title, String desc, int x,ProgressDialog pr) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.normal,
          fontFamily: 'Raleway',
        )),
    onPressed: () {
      if (Navigator.canPop(context) == true) {
        Navigator.pop(context);
        if (x == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BoardView()));
        }

        if (pr.isShowing()) {
          pr.hide();
        }
      }
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.normal,
        fontFamily: 'Raleway',
      ),
    ),
    titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
    backgroundColor: Color.fromRGBO(55, 75, 167, 1),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    content: Text(
      desc,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.normal,
        fontFamily: 'Raleway',
      ),
    ),
    actions: [
      okButton,
    ],
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
