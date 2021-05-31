import 'package:chat_app_chuyen_de/helper/constants.dart';
import 'package:chat_app_chuyen_de/helper/theme.dart';
import 'package:chat_app_chuyen_de/services/database.dart';
import 'package:chat_app_chuyen_de/view/chat.dart';
import 'package:chat_app_chuyen_de/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchEditingController = TextEditingController();

  bool isLoading = false;
  bool haveUserSearched = false;
  DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot searchSnapshot;

  initiateSearch() async {
    return await databaseMethods
        .getUserByUserName(searchEditingController.text)
        .then((value) {
      searchSnapshot = value;
      setState(() {
        isLoading = false;
        haveUserSearched = true;
      });
    });
  }

  Widget searchList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            itemCount: searchSnapshot.documents.length,
            itemBuilder: (context, index) {
              return itemUserTitle(
                searchSnapshot.documents[index].data["name"],
                searchSnapshot.documents[index].data["email"],
              );
            },
          )
        : Container();
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  createChatRoom(String userEmail) async {
    if (userEmail != Constants.myEmail) {
      String chatRoomId = getChatRoomId(userEmail, Constants.myEmail);
      List<String> users = [userEmail, Constants.myEmail];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };

      await databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Chat(
                    userEmail: userEmail,
                    chatRoomId: chatRoomId,
                  )));
    } else {
      Utils.showToast("bạn không thể gửi tin nhắn cho chính mình");
      print(
          "you cannot send message to yourself / bạn không thể gửi tin nhắn cho chính mình");
    }
  }

  Widget itemUserTitle(String userName, String userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(radius: 15,
              backgroundColor: Colors.blue,
              child: Text(userName.substring(0, 1)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoom(userEmail);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Chat',
            style: Styles.styles1(fontWeight: FontWeight.bold),
          ),
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
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: Colors.black26),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchEditingController,
                              style: Styles.styles1(fontSize: 16),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 20,
                                    color: Colors.white54,
                                  ),
                                  hintText: "Tìm kiếm bạn bè",
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none),
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                initiateSearch();
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                searchEditingController.clear();
                              });
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(40)),
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.clear_sharp,
                                  size: 14,
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                    ),
                    searchList(),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
