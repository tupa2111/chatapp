import 'package:chat_app_chuyen_de/helper/theme.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Quên mật khẩu',
          style: Styles.styles1(),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
              child: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.black,
          )),
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: Colors.blueAccent),
            child: Text('Mình chưa làm xong vui lòng quay lại !'),
          ),
        ),
      ),
    );
  }
}
