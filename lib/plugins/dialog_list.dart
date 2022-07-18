/*================================== show alert */


import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../board.dart';

late ProgressDialog pr;

void initPr(BuildContext context)
{


  pr = ProgressDialog(context,
      type: ProgressDialogType.normal, isDismissible: false);

  //Optional
  pr.style(
    padding: const EdgeInsets.all(16),
    message: 'Please wait...',
    borderRadius: 3.0,
    backgroundColor: Colors.white,
    progressWidget: const CircularProgressIndicator(
      strokeWidth: 3,
      backgroundColor: Color.fromRGBO(55, 75, 167, 1),
    ),
    elevation: 2.0,
    insetAnimCurve: Curves.bounceIn,
    progressTextStyle: const TextStyle(
        color:Color.fromRGBO(55, 75, 167, 1), fontSize: 2.0, fontWeight: FontWeight.w400),
    messageTextStyle: const TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.normal,
        color: Colors.grey),
  );

  //============================================= loading dialoge

}
showAlertDialog(BuildContext context, String title, String desc) {
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
      if (desc == "Login Successfull!") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BoardView()));
      } else {
        print(context);
        try {

          if ((Navigator?.canPop(context) == true)!) {
            Navigator.pop(context);
          }
          if (pr.isShowing()) {
            pr.hide();
          }
        }

        catch (e) {
print(e);

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

/*================================== show alert */


