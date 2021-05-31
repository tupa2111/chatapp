import 'dart:async';

import 'package:chat_app_chuyen_de/helper/constants.dart';
import 'package:chat_app_chuyen_de/helper/theme.dart';
import 'package:chat_app_chuyen_de/services/database.dart';
import 'package:chat_app_chuyen_de/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String userEmail;
  final String chatRoomId;

  const Chat({
    Key key,
    this.userEmail,
    this.chatRoomId,
  }) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController messageEditingController = TextEditingController();
  Stream<QuerySnapshot> streamChats;
  DatabaseMethods databaseMethods = DatabaseMethods();
  bool clearMessage = false;
  ScrollController _scrollController = ScrollController();
  bool scroll = false;

  // bool onMessage = false;

  Widget chatMessageList() {
    return StreamBuilder(
        stream: streamChats,
        builder: (context, snapshot) {
          if(_scrollController.hasClients){
            Timer(
                Duration(milliseconds: 50),
                    () => _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent ));
          }
          return snapshot.hasData
              ? Container(
                  padding: const EdgeInsets.only(bottom: 65),
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data.documents;
                        return MessageTile(
                          message: data[index].data["message"],
                          sendByMe:
                              Constants.myEmail == data[index].data["sendBy"],
                        );
                      }),
                )
              : Container();
        });
  }

  sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageEditingController.text,
        "sendBy": Constants.myEmail,
        "time": DateTime.now().microsecondsSinceEpoch,
      };
      databaseMethods.addMessagesToChat(widget.chatRoomId, messageMap);
    }
  }

  @override
  void initState() {
    databaseMethods.getMessagesFromChat(widget.chatRoomId).then((value) {
      if (value != null) {
        setState(() {
          streamChats = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height / 2;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget?.userEmail ?? "Chat App",
            style: Styles.styles1(fontWeight: FontWeight.bold)),
        elevation: 0.0,
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Color(0xffdddddd).withOpacity(0.8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      onEditingComplete: () {
                        sendMessage();
                        messageEditingController.clear();
                        Timer(
                            Duration(milliseconds: 50),
                            () => _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent));
                      },
                      controller: messageEditingController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                          hintText: "Nhắn gì đó..",
                          hintStyle: TextStyle(
                            color: Colors.black26,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    )),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        Timer(
                            Duration(milliseconds: 50),
                            () => _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent));
                        Timer(
                            Duration(milliseconds: 50),
                            () => _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent));
                        sendMessage();
                        messageEditingController.clear();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0x36FFFFFF),
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.send,
                            size: 18,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: sendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
          color: sendByMe ? const Color(0xff007EF4) : const Color(0xffdddddd),
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: sendByMe ? Colors.white : Colors.black,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w400)),
      ),
    );
  }
}
