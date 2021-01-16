import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_ninja/comment.dart';


import 'package:http/http.dart' as http;

import 'Post.dart';
import 'user.dart';
 
class UserDetailsScreen extends StatefulWidget {
  final Post postsss;
  final User usersss;

  // UserDetailsScreen(this.postsss, this.usersss);
  const UserDetailsScreen({Key key, this.postsss, this.usersss}) : super(key: key);


//    @override
//    _UserDetailsScreenState createState() => _UserDetailsScreenState(postsss, usersss);
//  }

   @override
   _UserDetailsScreenState createState() => _UserDetailsScreenState();
 }


class _UserDetailsScreenState extends State<UserDetailsScreen> {

  // Post posts;
  // User users;
  // _UserDetailsScreenState(Post postsss, User usersss);

  @override
  void initState() {
    super.initState();
    // posts = widget.postsss;
    // users = widget.usersss;

  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff6B2480),
          title: Text(widget.usersss.username),
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
                          child: 
                          Column(children: [
                        SizedBox(height: 15),
                        Row(children: [
                          SizedBox(width:5),
                          Container(
                            width: 125.0,
                            height: 125.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "http://sopmathpowy2.com/BoDiary/images/userimages/${widget.usersss.userimage}.jpg"),
                                  // image:AssetImage('assets/images/ic_logo_transparent.png')
                                  fit: BoxFit.fill,
                                ))),
                          SizedBox(width: 15),
                          Text(widget.usersss.username,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ]),
                        SizedBox(height: 15),

                      ])),
                    ],
                  )),
                ],
              ))),
        ])
      );
  }
}