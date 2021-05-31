import 'package:chat_app_chuyen_de/helper/authenticate.dart';
import 'package:chat_app_chuyen_de/helper/constants.dart';
import 'package:chat_app_chuyen_de/helper/helperfunctions.dart';
import 'package:chat_app_chuyen_de/helper/theme.dart';
import 'package:chat_app_chuyen_de/services/auth.dart';
import 'package:chat_app_chuyen_de/services/database.dart';
import 'package:chat_app_chuyen_de/view/search.dart';
import 'package:chat_app_chuyen_de/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthService authService = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream<QuerySnapshot> chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return ChatRoomsTile(
                        userEmail: snapshot
                            .data.documents[index].data['chatRoomId']
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(Constants.myEmail, ""),
                        userName: snapshot
                            .data.documents[index].data['chatRoomId']
                            .toString(),
                        chatRoomId:
                            snapshot.data.documents[index].data["chatRoomId"],
                      );
                    },
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/image/cover.jpg'),
                  )),
                );
        });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    databaseMethods.getChatRoom(Constants.myEmail).then((value) {
      if (value != null) {
        setState(() {
          chatRoomStream = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Hello ${Constants.myEmail}",
            style: Styles.styles1(fontWeight: FontWeight.bold),
          ),
          leading: Text(''),
          centerTitle: true,
          elevation: 0,
          actions: [
            GestureDetector(
              onTap: () {
                authService.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Container(
                  padding: EdgeInsets.only(right: 8),
                  color: Colors.transparent,
                  child: Icon(
                    Icons.close,
                    size: 32,
                    color: Colors.black,
                  )),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Colors.black26),
                child: TextField(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Search())),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tìm kiếm bạn bè",
                    hintStyle: TextStyle(
                        color: Colors.white54, fontWeight: FontWeight.bold),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
              chatRoomList(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userEmail;
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId, this.userEmail});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      userEmail: userEmail,
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black26, borderRadius: BorderRadius.circular(13)),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: CustomTheme.colorAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Image(
                image: AssetImage('assets/image/cover.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(userEmail,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w400)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
