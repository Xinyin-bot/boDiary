import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_ninja/comment.dart';
import 'package:food_ninja/user.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import 'Post.dart';


Color mainColor = Color(0xff6B2480);
Color secondColor = Color(0xffD8399B);
Color thirdColor = Color(0xffF78484);
Color forthColor = Color(0xffFDBE89);


class PostDetailsScreen extends StatefulWidget {
  final Post postsss;
  final User usersss;

  PostDetailsScreen(this.postsss, this.usersss);

  @override
  _PostDetailsScreenState createState() =>
      _PostDetailsScreenState(postsss, usersss);
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  Post posts;
  User users;

  _PostDetailsScreenState(Post postsss, User usersss);

  List commentList;
  //List userList;

  String titlecenter = "Loading Posts......";

  final TextEditingController _commentcontroller = TextEditingController();

  String _commentcaption = "";

  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;

  @override
  void initState() {
    super.initState();
    posts = widget.postsss;
    users = widget.usersss;

    _keyboardState = _keyboardVisibility.isKeyboardVisible;
    print(_keyboardState);

    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardState = visible;
          print(_keyboardState);
        });
      },
    );
    

    _loadComments();
    //_loadUsers();
  }

  // @override
  // void dispose() {
  //   _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text('Post'),
        ),
        body: Column(children: [
          Container(
              padding: EdgeInsets.all(3),
              child: (Column(
                children: [
                  Container(
                      //padding: EdgeInsets.all(20),
                      child: Column(
                    children: [
                      Container(
                          child: Column(children: [
                        SizedBox(height: 15),
                        Row(children: [
                          SizedBox(width: 5),
                          Container(
                              width: 45.0,
                              height: 45.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "http://sopmathpowy2.com/BoDiary/images/userimages/${users.userimage}.jpg"),
                                    // image:AssetImage('assets/images/ic_logo_transparent.png')
                                    fit: BoxFit.fill,
                                  ))),
                          SizedBox(width: 15),
                          Text(posts.username,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ]),
                        SizedBox(height: 15),
                        Container(
                            // height: screenHeight / 3.8,
                            // width: screenWidth / 1.2,
                            child: CachedNetworkImage(
                          imageUrl:
                              "http://sopmathpowy2.com/BoDiary/images/postimages/${posts.postimage}.jpg",
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) => new Icon(
                            Icons.broken_image,
                            size: screenWidth / 2,
                          ),
                        )),
                        SizedBox(height: 5),
                        Row(children: [
                          Text(posts.postcaption,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ]),

                        //Text(DateFormat('yyyy-MM-dd hh:mm aaa').format(postList[index]['postdate'])),
                        Row(children: [
                          Text(posts.postdate),
                        ]),
                      ])),
                    ],
                  )),
                ],
              ))),
          Expanded(
            child: SingleChildScrollView(
              child: commentList == null
                  ?
                  // ? Flexible(
                  //     child: Container(
                  //         child: Center(
                  //             child: Text(
                  //     titlecenter,
                  //     style: TextStyle(
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.black),
                  //   ))))
                  Container(
                      child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                                "No Comment"),
                          )))
                  : Container(
                      child: Container(
                          padding: EdgeInsets.all(20),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: commentList.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                // print(commentList.length);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(commentList[index]['username'],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                                    Text(commentList[index]['commentcaption']),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              }))),
            ),
          ),
          TextField(
              controller: _commentcontroller,
              decoration: InputDecoration(
                  labelText: "Comment",
                  suffixIcon: IconButton(
                    onPressed: () {
                      _updatenewcomment();
                    },
                    icon: Icon(Icons.send),
                  ))),
        ]));
  }

  void _loadComments() {
    print("Load " + widget.postsss.postid + "'s Data");

    http.post("http://sopmathpowy2.com/BoDiary/php/load_comments.php", body: {
      "postid": widget
          .postsss.postid, //send the postid to load_comments.php to get data
    }).then((res) {
      print(res.body);

      if (res.body == "nodata") {
        print("commentList is null");
        commentList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body); //decode json data

          commentList = jsondata["comments"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _updatenewcomment() {
    final dateTime  = DateTime.now();
    _commentcaption = _commentcontroller.text;

    http.post("http://sopmathpowy2.com/BoDiary/php/add_newComment.php", body: {
      "postid": posts.postid,
      "commentcaption": _commentcaption,
      "useremail": users.useremail,
      "username": users.username,
      "datecomment": "-${dateTime.microsecondsSinceEpoch}",
    }).then((res) {
      print(res.body);

      if (res.body == "succes") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.pop(context);
      } else {
        Toast.show(
          "Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  // void _loadUsers() {
  //   print("Load " + widget.usersss.username + "'s Data");

  //   http.post("http://sopmathpowy2.com/BoDiary/php/load_user.php", body: {
  //     "useremail": widget.usersss.useremail, //send the useremail to load_user.php to get data
  //   }).then((res) {
  //     print(res.body);

  //     if (res.body == "nodata") {
  //       print("userList is null");
  //       userList = null;
  //     } else {
  //       setState(() {
  //         var jsondata = json.decode(res.body); //decode json data

  //         userList = jsondata["users"];
  //       });
  //     }
  //   }).catchError((err) {
  //     print(err);
  //   });
  // }

  // _loadcommentsDetail(int index) {
  //   Comment comment = new Comment(
  //     commentid: commentList[index]['commentid'],
  //     postid: posts.postid,
  //     commentcaption: commentList[index]['commentcaption'],
  //     useremail: commentList[index]['useremail'],
  //     username: commentList[index]['username'],
  //     datecomment: commentList[index]['datecomment'],
  //   );

  //   //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FoodScreen(foods: food)));
  // }

}
