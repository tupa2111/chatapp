import 'package:chat_app_chuyen_de/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    title: Text('Chat App',style: Styles.styles1(fontWeight: FontWeight.bold),),
    elevation: 0.0,
    centerTitle: true,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    border: InputBorder.none,
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.white54,fontWeight: FontWeight.bold),
  );
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16,);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17,);
}

class Utils{
  static void showToast(String title, {bool isLong: false}) {
    if (title != null) {
      Fluttertoast.showToast(
        msg: title,
        toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white.withOpacity(0.5),
        textColor: Colors.white,
      );
    }
  }
}
