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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff6B2480),
          title: Text(widget.usersss.username),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      );
  }
}