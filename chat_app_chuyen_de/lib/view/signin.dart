import 'package:chat_app_chuyen_de/helper/helperfunctions.dart';
import 'package:chat_app_chuyen_de/helper/theme.dart';
import 'package:chat_app_chuyen_de/services/auth.dart';
import 'package:chat_app_chuyen_de/services/database.dart';
import 'package:chat_app_chuyen_de/view/chatRoom.dart';
import 'package:chat_app_chuyen_de/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'forgetpassword.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({Key key, this.toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isCover = true;
  QuerySnapshot snapshotUserInfo;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      authService
          .signInWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((value) {
        if (value != null) {
          databaseMethods
              .getUserByUserEmail(emailEditingController.text)
              .then((value) {
            if (value != null) {
              snapshotUserInfo = value;
              HelperFunctions.saveUserEmailSharedPreference(
                  snapshotUserInfo.documents[0].data["email"]);
              HelperFunctions.saveUserNameSharedPreference(
                  snapshotUserInfo.documents[0].data["name"]);
              HelperFunctions.saveUserLoggedInSharedPreference(true);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChatRoom()));
            }
          });
        } else {
          setState(() {
            isLoading = false;
          });
          Utils.showToast("Tài khoản hoặc mật khẩu không hợp lệ");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                isCover = true;
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Spacer(),
                    isCover == true
                        ? Container(
                            padding: EdgeInsets.only(bottom: 30),
                            child: Image(
                              image: AssetImage('assets/image/cover.jpg'),
                              width: 150,
                              height: 150,
                            ),
                          )
                        : Container(),
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Đăng nhập bằng Email và số điện thoại hoặc tài khoản Google',
                        textAlign: TextAlign.center,
                        style: Styles.styles1(fontSize: 18),
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                color: Color(0xff323232).withOpacity(0.5),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(13),
                                    topRight: Radius.circular(13))),
                            child: TextFormField(
                              onTap: () {
                                setState(() {
                                  isCover = false;
                                });
                              },
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Vui lòng nhập chính xác email";
                              },
                              controller: emailEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("Email"),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 1),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                color: Color(0xff323232).withOpacity(0.5),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(13),
                                    bottomLeft: Radius.circular(13))),
                            child: TextFormField(
                              onTap: () {
                                setState(() {
                                  isCover = false;
                                });
                              },
                              obscureText: true,
                              validator: (val) {
                                return val.length > 6
                                    ? null
                                    : "Nhập mật khẩu từ 6 ký tự trở lên";
                              },
                              style: simpleTextStyle(),
                              controller: passwordEditingController,
                              decoration: textFieldInputDecoration("Mật khẩu"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 16,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                "Quên mật khẩu?",
                                style: Styles.styles1(fontSize: 16),
                              )),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        signIn();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xff007EF4),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Đăng nhập",
                          style: biggerTextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black12),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Đăng nhập với Google",
                        style: TextStyle(
                            fontSize: 17, color: CustomTheme.textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account? ",
                          style: Styles.styles1(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggleView();
                          },
                          child: Text(
                            "Register now",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    isCover == true
                        ? SizedBox(
                            height: 10,
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
    );
  }
}
