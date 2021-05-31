import 'package:chat_app_chuyen_de/helper/helperfunctions.dart';
import 'package:chat_app_chuyen_de/helper/theme.dart';
import 'package:chat_app_chuyen_de/services/auth.dart';
import 'package:chat_app_chuyen_de/services/database.dart';
import 'package:chat_app_chuyen_de/widgets/widget.dart';
import 'package:flutter/material.dart';

import 'chatRoom.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  const SignUp({Key key, this.toggleView}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isCover = true;

  signUp() async {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "name": usernameEditingController.text,
        "email": emailEditingController.text
      };

      setState(() {
        isLoading = true;
      });
      authService
          .signUpWithEmailAndPassword(
          emailEditingController.text, passwordEditingController.text)
          .then((value) {
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserEmailSharedPreference(
            emailEditingController.text);
        HelperFunctions.saveUserNameSharedPreference(
            usernameEditingController.text);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
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
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : GestureDetector(
        onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          isCover = true;
        });
      },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Spacer(),
              isCover == true
                  ? Container(
                padding: EdgeInsets.only(bottom: 15),
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
                  'Đăng ký tài khoản hoặc đăng nhập bằng tài khoản Google',
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
                        style: simpleTextStyle(),
                        controller: usernameEditingController,
                        validator: (val) {
                          return val.isEmpty || val.length < 3
                              ? "Enter Username 3+ characters"
                              : null;
                        },
                        decoration: textFieldInputDecoration("Tên tài khoản"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 1),
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(color: Color(0xff323232).withOpacity(0.5)),
                      child: TextFormField(
                        onTap: () {
                          setState(() {
                            isCover = false;
                          });
                        },
                        controller: emailEditingController,
                        style: simpleTextStyle(),
                        validator: (val) {
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)
                              ? null
                              : "Enter correct email";
                        },
                        decoration: textFieldInputDecoration("Email"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                          color: Color(0xff323232).withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(13),
                              bottomRight: Radius.circular(13))),
                      child: TextFormField(
                        onTap: () {
                          setState(() {
                            isCover = false;
                          });
                        },
                        obscureText: true,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Mật khẩu"),
                        controller: passwordEditingController,
                        validator: (val) {
                          return val.length < 6
                              ? "Enter Password 6+ characters"
                              : null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  signUp();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xff007EF4),
                    // gradient: LinearGradient(
                    //   List: [
                    //     const Color(0xff007EF4),
                    //     const Color(0xff2A75BC)
                    //   ],
                    // ),
                  ),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
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
              isCover == true
                  ? Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black12),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Text(
                  "Đăng nhập với Google",
                  style: TextStyle(
                      fontSize: 17, color: CustomTheme.textColor),
                  textAlign: TextAlign.center,
                ),
              )
                  : Container(),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Bạn đã có tạo một tài khoản? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggleView();
                    },
                    child: Text(
                      "Đăng nhập ngay",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
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
